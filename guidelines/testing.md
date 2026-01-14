# Testing Guide

This project includes three types of tests to ensure code quality.

---

## Test Types

### 1. Unit Tests
**What:** Test individual functions and business logic in isolation.

**What we test:**
- Provider logic (auth state, data fetching)
- Controllers (login, signup flows)
- Validation functions
- Service layer (Supabase wrapper)

**Location:** `test/providers/`, `test/services/`

**Why:** Catch logic bugs early, fast to run, easy to write.

---

### 2. Widget Tests
**What:** Test how UI components render and respond to user interaction.

**What we test:**
- Screens render correctly
- Forms validate inputs
- Buttons trigger correct actions
- Error states display properly

**Location:** `test/widgets/`, `test/screens/`

**Why:** Ensure UI behaves as expected without manual testing.

---

### 3. Integration Tests (Optional)
**What:** Test complete user flows end-to-end.

**What we test:**
- Full auth flow (signup → verify → login)
- Critical user journeys

**Location:** `integration_test/`

**Why:** Verify the whole system works together. Slower, but catches integration issues.

---

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/providers/auth_provider_test.dart
```

---

## Testing Strategy

**Focus on:**
- ✅ Business logic (providers, controllers) – **High coverage**
- ✅ Validation functions – **100% coverage**
- ✅ Critical UI flows – **Widget tests for key screens**

**Don't over-test:**
- ❌ Framework code (Flutter widgets)
- ❌ UI styling (margins, colors)
- ❌ Private methods

---

## Mocking

We use **mocks** to replace real Supabase in tests:
- Tests run fast (no network calls)
- Tests are reliable (no flaky external dependencies)

**What gets mocked:**
- Supabase service (`SupabaseService`)
- Auth providers
- Database responses

---

## Coverage Target

- **Providers/Controllers:** 80%+
- **Validation:** 100%
- **Widgets:** 50%+

**Don't chase 100% coverage** – focus on critical paths.

---

## Example Test Files

Check these for reference:
- `test/providers/auth_provider_test.dart` – Provider testing pattern
- `test/widgets/login_screen_test.dart` – Widget testing pattern

---

## Before You Ship

- [ ] Critical providers tested
- [ ] Validation functions covered
- [ ] Key screens have widget tests
- [ ] All tests pass: `flutter test`

---

**That's it!** Testing doesn't have to be complicated. Write tests that give you confidence without slowing you down.
