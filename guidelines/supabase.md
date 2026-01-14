# Supabase Development Guidelines – ConnectIt

## CLI-First Development

**IMPORTANT:** All developers must use the Supabase CLI for local development!

### Installation

```bash
# macOS
brew install supabase/tap/supabase

# Or via npm
npm install -g supabase
```

### Check CLI Version
```bash
supabase --version

# Update if needed
brew upgrade supabase
```

---

## Local Development

### 1. Initialize Project

```bash
# In project root (already done once)
supabase init
```

This creates:
- `supabase/` directory
- `supabase/config.toml` – Local configuration
- `supabase/seed.sql` – Seed data for local DB

### 2. Start Local Supabase

```bash
supabase start
```

**Output contains:**
- `API URL` – For local development
- `anon key` – For frontend `.env`
- `service_role key` – For backend tests
- `DB URL` – For direct DB connection
- `Studio URL` – Local Supabase Studio (UI)

### 3. Stop After Development

```bash
supabase stop
```

### 4. Complete Reset (delete all data)

```bash
supabase db reset
```

---

## Database Migrations

### RULE: Create Migrations ONLY via CLI!

**❌ NEVER:**
- Execute SQL directly in Supabase Studio
- Create tables manually without migration
- Make schema changes without migration file

**✅ ALWAYS:**
- Use `supabase migration new`
- Commit migration files to Git
- Test migrations locally before deployment

### Create Migration

```bash
# Create new migration
supabase migration new create_users_table

# Creates: supabase/migrations/<timestamp>_create_users_table.sql
```

### Migration File Example

```sql
-- supabase/migrations/20240114_create_users_table.sql

-- Create users table
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  organization TEXT,
  role TEXT,
  linkedin_url TEXT,
  bio TEXT,
  pitch TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own profile"
  ON public.users
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.users
  FOR UPDATE
  USING (auth.uid() = id);

-- Indexes
CREATE INDEX idx_users_email ON public.users(email);

-- Update timestamp trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

### Apply Migration

```bash
# Apply locally
supabase db reset  # Complete rebuild

# Or apply only new migrations
supabase migration up

# Check status
supabase migration list
```

### Push Migration to Remote

```bash
# Link with Supabase project (once)
supabase link --project-ref <project-id>

# Push migrations to remote
supabase db push

# Or: Bring remote DB to migration state
supabase db reset --db-url <remote-database-url>
```

---

## Frontend Models for Supabase Tables

### RULE: Each Table = One Freezed Model

For each Supabase table, a corresponding Flutter model must exist:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required String name,
    String? organization,
    String? role,
    @JsonKey(name: 'linkedin_url') String? linkedinUrl,
    String? bio,
    String? pitch,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
```

### Important Points

1. **`@JsonKey` for snake_case**
   ```dart
   @JsonKey(name: 'created_at') required DateTime createdAt,
   ```

2. **`fromJson` Factory**
   ```dart
   factory UserProfile.fromJson(Map<String, dynamic> json) =>
       _$UserProfileFromJson(json);
   ```

3. **Nullable vs Required**
   - DB `NOT NULL` → `required` in model
   - DB nullable → `?` in model

4. **UUIDs as String**
   ```dart
   required String id,  // UUIDs always as String
   ```

### Model Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Row Level Security (RLS)

### RULE: RLS is MANDATORY for all tables!

**Every table must have RLS:**

```sql
ALTER TABLE public.my_table ENABLE ROW LEVEL SECURITY;
```

### Standard Policies

#### 1. User can read own data

```sql
CREATE POLICY "Users can view own data"
  ON public.users
  FOR SELECT
  USING (auth.uid() = id);
```

#### 2. User can modify own data

```sql
CREATE POLICY "Users can update own data"
  ON public.users
  FOR UPDATE
  USING (auth.uid() = id);
```

#### 3. Only authenticated users can read

```sql
CREATE POLICY "Authenticated users can read"
  ON public.events
  FOR SELECT
  USING (auth.role() = 'authenticated');
```

#### 4. Organizer-specific

```sql
CREATE POLICY "Event organizers can manage their events"
  ON public.events
  FOR ALL
  USING (
    auth.uid() IN (
      SELECT user_id FROM event_organizers WHERE event_id = id
    )
  );
```

### RLS Best Practices

- **Default DENY:** Without policy, access is forbidden
- **Minimal Permissions:** As few rights as necessary
- **Performance:** Index RLS queries
- **Testing:** Test RLS with different user IDs

---

## Realtime Subscriptions

### Enable Realtime for Table

```sql
-- In migration file
ALTER PUBLICATION supabase_realtime ADD TABLE public.events;
```

### Flutter Realtime Usage

```dart
@riverpod
Stream<List<Event>> eventsStream(Ref ref) {
  return Supabase.instance.client
      .from('events')
      .stream(primaryKey: ['id'])
      .map((data) => data.map((json) => Event.fromJson(json)).toList());
}
```

### Realtime Best Practices

- Only enable for tables that really need it
- Primary key MUST be specified
- RLS applies to Realtime too!

---

## Storage (for Images & Files)

### Create Bucket (via Migration)

```sql
-- Storage bucket for profile pictures
INSERT INTO storage.buckets (id, name, public)
VALUES ('profiles', 'profiles', true);

-- RLS for Storage
CREATE POLICY "Users can upload own profile picture"
  ON storage.objects
  FOR INSERT
  WITH CHECK (
    bucket_id = 'profiles' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Public can view profile pictures"
  ON storage.objects
  FOR SELECT
  USING (bucket_id = 'profiles');
```

### Flutter Storage Upload

```dart
Future<String> uploadProfilePicture(File file) async {
  final userId = Supabase.instance.client.auth.currentUser!.id;
  final path = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
  
  await Supabase.instance.client.storage
      .from('profiles')
      .upload(path, file);
  
  return Supabase.instance.client.storage
      .from('profiles')
      .getPublicUrl(path);
}
```

---

## Edge Functions

### Create Edge Function

```bash
supabase functions new send-event-invitation
```

Creates: `supabase/functions/send-event-invitation/index.ts`

### Example: Send Event Invitation

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const { eventId, userIds } = await req.json()
  
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
  )
  
  // Logic here...
  
  return new Response(
    JSON.stringify({ success: true }),
    { headers: { "Content-Type": "application/json" } }
  )
})
```

### Deploy Edge Function

```bash
# Test locally
supabase functions serve send-event-invitation

# Deploy
supabase functions deploy send-event-invitation
```

---

## Seed Data (for local development)

### Seed File: `supabase/seed.sql`

```sql
-- Create test users
INSERT INTO public.users (id, email, name, organization)
VALUES 
  ('00000000-0000-0000-0000-000000000001', 'test@example.com', 'Test User', 'TestCo'),
  ('00000000-0000-0000-0000-000000000002', 'admin@example.com', 'Admin User', 'AdminCo');

-- Create test event
INSERT INTO public.events (id, name, date, organizer_id)
VALUES 
  ('10000000-0000-0000-0000-000000000001', 'Test Event', NOW() + INTERVAL '7 days', '00000000-0000-0000-0000-000000000001');
```

Seeds are automatically applied with `supabase db reset`.

---

## Database Schema Conventions

### Naming Conventions

- **Tables:** `snake_case`, Plural (`users`, `events`, `event_participants`)
- **Columns:** `snake_case` (`created_at`, `linkedin_url`)
- **Primary Keys:** Always `id` (UUID)
- **Foreign Keys:** `<table>_id` (`user_id`, `event_id`)
- **Timestamps:** `created_at`, `updated_at`

### Standard Fields for Every Table

```sql
CREATE TABLE public.my_table (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  -- ... your fields ...
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Soft Deletes (optional)

```sql
ALTER TABLE public.users ADD COLUMN deleted_at TIMESTAMP WITH TIME ZONE;

-- Policy: Hide deleted records
CREATE POLICY "Hide deleted records"
  ON public.users
  FOR SELECT
  USING (deleted_at IS NULL);
```

---

## Testing

### Local Tests with CLI

```bash
# Rebuild database completely
supabase db reset

# Apply seed data
# (Happens automatically with reset)

# Open Supabase Studio
supabase start
# → http://localhost:54323
```

### Integration Tests (Flutter)

```dart
void main() {
  setUpAll(() async {
    await Supabase.initialize(
      url: 'http://localhost:54321',  // Local Supabase
      anonKey: 'your-local-anon-key',
    );
  });
  
  test('Create user profile', () async {
    final response = await Supabase.instance.client
        .from('users')
        .insert({'email': 'test@example.com', 'name': 'Test'})
        .select()
        .single();
    
    expect(response['email'], 'test@example.com');
  });
}
```

---

## Environment Variables

### Local Development (`.env`)

```env
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=<local-anon-key-from-supabase-start>
```

### Production (`.env.production`)

```env
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=<production-anon-key>
```

### IMPORTANT: Never commit `.env`!

```gitignore
.env
.env.local
.env.production
```

---

## Deployment Workflow

### 1. Develop Locally

```bash
supabase start
# Develop & test
supabase migration new my_feature
supabase db reset  # Rebuild local DB
```

### 2. Commit Migration

```bash
git add supabase/migrations/
git commit -m "Add migration for feature X"
git push
```

### 3. Deploy to Production

```bash
# Link with project
supabase link --project-ref <project-id>

# Push migrations to production
supabase db push

# Or: Rebuild remote DB completely (WARNING: Deletes data!)
# supabase db reset --db-url <remote-url>
```

### 4. Deploy Edge Functions

```bash
supabase functions deploy <function-name>
```

---

## Best Practices Checklist

### Database
- [ ] Every table has RLS
- [ ] Migrations for every schema change
- [ ] Indexes for frequent queries
- [ ] `created_at` & `updated_at` timestamps
- [ ] Foreign key constraints
- [ ] Follow naming conventions

### Frontend
- [ ] Freezed model for every table
- [ ] `fromJson` factory present
- [ ] `@JsonKey` for snake_case mapping
- [ ] Types match DB schema

### Security
- [ ] RLS enabled for all tables
- [ ] Minimal permissions (Least Privilege)
- [ ] Service role key only for backend/functions
- [ ] Anon key for frontend

### Development
- [ ] Local Supabase for development
- [ ] Seed data for tests
- [ ] Test migrations before merge
- [ ] Clean Git history (migrations committed)

### Performance
- [ ] Indexes on foreign keys
- [ ] Indexes on frequently filtered columns
- [ ] Avoid N+1 queries (use joins)
- [ ] Realtime only where needed

---

## Common Patterns

### 1. User-Event Relationship (Many-to-Many)

```sql
-- Junction Table
CREATE TABLE event_participants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id UUID REFERENCES events(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'registered',  -- registered, checked_in
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(event_id, user_id)
);

CREATE INDEX idx_event_participants_event ON event_participants(event_id);
CREATE INDEX idx_event_participants_user ON event_participants(user_id);
```

### 2. Audit Logging

```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name TEXT NOT NULL,
  record_id UUID NOT NULL,
  action TEXT NOT NULL,  -- insert, update, delete
  changed_by UUID REFERENCES users(id),
  changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  old_data JSONB,
  new_data JSONB
);

-- Create trigger
CREATE OR REPLACE FUNCTION audit_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (table_name, record_id, action, changed_by, new_data)
  VALUES (TG_TABLE_NAME, NEW.id, TG_OP, auth.uid(), row_to_json(NEW));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 3. Full-Text Search

```sql
-- Add search column
ALTER TABLE users ADD COLUMN search_vector tsvector;

-- Create index
CREATE INDEX idx_users_search ON users USING gin(search_vector);

-- Auto-update trigger
CREATE OR REPLACE FUNCTION users_search_trigger()
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector :=
    to_tsvector('english', COALESCE(NEW.name, '') || ' ' || COALESCE(NEW.organization, ''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_search
  BEFORE INSERT OR UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION users_search_trigger();
```

---

## Troubleshooting

### Migration Fails

```bash
# Check status
supabase migration list

# Rollback last migration (locally)
supabase db reset

# Adjust migration file and try again
```

### Local Supabase Won't Start

```bash
# Check Docker containers
docker ps

# Ports occupied? Stop other Supabase instance
supabase stop --no-backup

# Start fresh
supabase start
```

### RLS Policy Not Working

```sql
-- Policy check (in Supabase Studio)
SELECT * FROM public.users;  -- As authenticated user

-- Or via CLI
supabase db dump --data-only --table users
```

---

## Resources

- [Supabase CLI Docs](https://supabase.com/docs/guides/cli)
- [Supabase Migrations](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Realtime](https://supabase.com/docs/guides/realtime)
- [Edge Functions](https://supabase.com/docs/guides/functions)
