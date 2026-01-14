# CI/CD with GitHub Actions

This project uses GitHub Actions for automated testing and code quality checks.

---

## What Runs Automatically

### On Every Pull Request

**Flutter Tests**
- All unit tests run automatically
- Widget tests verify UI components
- Tests must pass before merging

**Code Formatting**
- Flutter formatter checks code style
- Ensures consistent formatting across the codebase
- Fails if code is not properly formatted

**Code Generation Check**
- Verifies all generated files are up-to-date
- Ensures developers ran `build_runner` before committing

---

## Why This Matters

**Catch Issues Early**
- Bugs found before code review
- Failed tests block merging
- No broken code in main branch

**Consistent Code Style**
- All code formatted the same way
- No formatting debates in reviews
- Easier to read and maintain

**Fast Feedback**
- Results in ~2-3 minutes
- No manual testing needed
- Focus on code logic in reviews

---

## How to Use

### Before Creating a PR

1. Run tests locally: `flutter test`
2. Format code: `flutter format .`
3. Generate code: `dart run build_runner build`
4. Commit and push

### If CI Fails

**Tests Failed:**
- Fix the broken tests
- Push the fix
- CI runs automatically again

**Formatting Failed:**
- Run `flutter format .`
- Commit the formatted code
- Push

**Code Generation Failed:**
- Run `dart run build_runner build --delete-conflicting-outputs`
- Commit generated files
- Push

---

## CI Configuration

The GitHub Actions workflow is located at:
- `.github/workflows/flutter-ci.yml`

It runs on:
- Every pull request
- Every push to `main` branch

**Note:** You can also run the workflow manually from GitHub Actions tab.
