# Frontend Guidelines

## Core Dependencies

### Required Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # Supabase & Auth
  supabase_flutter: ^2.5.6           # Supabase SDK + Auto-PKCE for Web
  
  # State Management
  flutter_riverpod: ^2.5.1           # Reactive State Management
  riverpod_annotation: ^2.5.1        # Annotations for Code-Gen
  
  # Routing
  go_router: ^16.2.4                 # Declarative Routing + Redirects
  
  # Configuration
  flutter_dotenv: ^5.1.0             # Environment Variables
  
  # Data Classes
  freezed_annotation: ^2.4.1         # Immutable Models
  
  # UI (optional)
  shadcn_ui: ^0.30.0                 # Modern UI Components
  cupertino_icons: ^1.0.6            # iOS Icons
```

### Dev Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.11              # Code-Gen Runner
  freezed: ^2.5.7                    # Freezed Generator
  riverpod_generator: ^2.5.1         # Riverpod Generator
  go_router_builder: ^3.0.1          # GoRouter Generator
  
  # Linting
  flutter_lints: ^6.0.0              # Official Flutter Lints
```

---

## Project Structure

```
lib/
├── app/
│   ├── router/
│   │   ├── router.dart              # GoRouter Config + Redirect Logic
│   │   └── routes.dart              # Typed Routes (generated)
│   └── core/
│       ├── scaffold_messenger.dart  # Global Snackbar
│       ├── splash_screen.dart       # Loading Screen
│       └── home_screen.dart         # Main App Screen
│
├── features/
│   ├── auth/                        # Authentication Feature
│   │   ├── models/
│   │   │   ├── auth_state.dart      # Freezed Union States
│   │   │   └── user_profile.dart    # User Model
│   │   ├── providers/
│   │   │   ├── auth_provider.dart   # Central Auth Logic
│   │   │   ├── login_controller.dart
│   │   │   ├── signup_controller.dart
│   │   │   └── ...                  # Per-Flow Controllers
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── ...
│   │   └── widgets/
│   │       └── ...                  # Feature-specific Widgets
│   │
│   └── ...                          # Add more features
│
├── shared/
│   ├── services/
│   │   └── supabase_service.dart    # Thin Supabase API Wrapper
│   ├── widgets/
│   │   ├── app_button.dart          # Reusable Button
│   │   ├── app_text_field.dart      # Reusable Input
│   │   ├── app_form.dart            # Form Wrapper
│   │   └── center_panel.dart        # Layout Helper
│   └── validators.dart              # Validation Functions
│
├── l10n/                            # Localization (i18n)
│   ├── app_de.arb
│   └── app_en.arb
│
└── main.dart                        # App Entry Point
```

---

## Code Style & Linting

### analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_use_package_imports      # Never use relative imports
    - require_trailing_commas          # Trailing commas required

analyzer:
  plugins:
    - custom_lint
  errors:
    invalid_annotation_target: ignore  # For Freezed + JSON
  exclude:
    - lib/**.freezed.dart
    - lib/**.g.dart
```

### Important Rules

1. **Always use `package:` imports**
   ```dart
   // ✅ Correct
   import 'package:flutter_supabase_template/features/auth/models/auth_state.dart';
   
   // ❌ Wrong
   import '../models/auth_state.dart';
   ```

2. **Trailing Commas**
   ```dart
   // ✅ Correct (better formatting)
   Widget build(BuildContext context) {
     return Column(
       children: [
         Text('Hello'),
         Text('World'),
       ],  // ← Trailing Comma
     );
   }
   ```

3. **Const Constructors**
   ```dart
   // ✅ Use const where possible
   const SizedBox(height: 16);
   const Text('Static Text');
   ```

---

## State Management – Riverpod

### Provider Pattern

```dart
// Auto-Generated Provider with riverpod_annotation
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    // Initial State
    return const AuthState.loading();
  }
  
  Future<void> signIn(String email, String password) async {
    state = const AuthState.loading();
    try {
      await ref.read(supabaseServiceProvider).signIn(email, password);
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
```

### Controller Pattern (for UI flows)

```dart
@riverpod
class LoginController extends _$LoginController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);
  
  Future<void> submit(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authProvider.notifier).signIn(email, password);
    });
  }
}
```

### Usage in Widgets

```dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final controller = ref.read(loginControllerProvider.notifier);
    
    return authState.when(
      loading: () => CircularProgressIndicator(),
      authenticated: () => HomeScreen(),
      unauthenticated: () => LoginForm(onSubmit: controller.submit),
      error: (msg) => ErrorWidget(msg),
    );
  }
}
```

---

## Routing – GoRouter

### Router Config

```dart
@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    redirect: (context, state) {
      // Redirect logic based on auth state
      if (authState is Unauthenticated && !state.matchedLocation.startsWith('/auth')) {
        return '/auth/login';
      }
      if (authState is Authenticated && state.matchedLocation.startsWith('/auth')) {
        return '/home';
      }
      return null;
    },
    routes: $appRoutes,  // Generated from routes.dart
  );
}
```

### Typed Routes

```dart
@TypedGoRoute<LoginRoute>(path: '/auth/login')
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouteState state) {
    return const LoginScreen();
  }
}
```

---

## Data Models – Freezed

### Union Types for States

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated({required User user}) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}
```

### Data Classes

```dart
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    String? organization,
    String? linkedinUrl,
  }) = _UserProfile;
  
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
```

---

## Supabase Integration

### Service Layer

```dart
@riverpod
SupabaseService supabaseService(Ref ref) => SupabaseService();

class SupabaseService {
  final _client = Supabase.instance.client;
  
  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  // More methods...
}
```

### Real-time Subscriptions

```dart
@riverpod
Stream<List<Contact>> contactsStream(Ref ref) {
  final userId = ref.watch(authProvider).user?.id;
  
  return Supabase.instance.client
      .from('contacts')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .map((data) => data.map((json) => Contact.fromJson(json)).toList());
}
```

---

## Validation

### Reusable Validators

```dart
String? validateEmail(BuildContext context, String? value) {
  final loc = AppLocalizations.of(context);
  if (value == null || value.isEmpty) {
    return loc.valEnterEmail;
  }
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRegex.hasMatch(value)) {
    return loc.valInvalidEmail;
  }
  return null;
}
```

---

## Environment Configuration

### .env File

```env
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJxxxx...
WEB_REDIRECT_URL=http://localhost:5500/
```

### Loading in main.dart

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,  // Important for Web!
    ),
  );
  
  runApp(const ProviderScope(child: App()));
}
```

---

## Testing

### Provider Tests

```dart
void main() {
  test('LoginController submits successfully', () async {
    final container = ProviderContainer(
      overrides: [
        supabaseServiceProvider.overrideWith((ref) => MockSupabaseService()),
      ],
    );
    
    final controller = container.read(loginControllerProvider.notifier);
    await controller.submit('test@example.com', 'password123');
    
    final state = container.read(loginControllerProvider);
    expect(state.hasError, false);
  });
}
```

### Widget Tests

```dart
void main() {
  testWidgets('LoginScreen shows error on failed login', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );
    
    await tester.enterText(find.byType(TextField).first, 'invalid@email');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    
    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
```

---

## Build & Deployment

### Code Generation

```bash
# One-off Build
dart run build_runner build --delete-conflicting-outputs

# Watch Mode (during development)
dart run build_runner watch --delete-conflicting-outputs
```

### Flutter Build Commands

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release

# Web (with fixed port for Supabase redirects)
flutter run -d chrome --web-port 5500
flutter build web --release
```

---

## Best Practices

### 1. Feature-First Organization
- Each feature has its own `models/`, `providers/`, `screens/`, `widgets/`
- Shared components in `lib/shared/`

### 2. Provider Granularity
- One provider per responsibility
- Controllers for UI flows (LoginController, SignupController)
- Service providers for API calls

### 3. Error Handling
- Use `AsyncValue.guard()` for automatic error handling
- Show user-friendly errors (no stack traces)

### 4. Performance
- `ConsumerWidget` instead of `StatefulWidget` where possible
- `select()` for targeted rebuilding
- `AutoDisposeProvider` for automatic cleanup

### 5. Accessibility
- Semantics for screen readers
- Pay attention to contrast ratios
- Keyboard navigation

---

## Resources

- [Riverpod Docs](https://riverpod.dev/)
- [GoRouter Docs](https://pub.dev/packages/go_router)
- [Freezed Docs](https://pub.dev/packages/freezed)
- [Supabase Flutter Docs](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
