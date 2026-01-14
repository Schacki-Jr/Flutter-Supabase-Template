# Flutter × Supabase Production Template

> *In an era where "vibe coding" is gaining popularity, developers often realize too late that they should have thought about their tech stack beforehand. This template gives you a head start with a modern, production-ready foundation.*

---

## 🎯 When to Use This Stack

| ✅ **Perfect For** | ❌ **Consider Alternatives** |
|-------------------|------------------------------|
| Mobile-first apps (iOS, Android) with web support | Pure web apps requiring SEO (use Next.js) |
| Real-time features (chat, live updates, collaboration) | Heavy AI workloads (Edge Functions timeout at 150s) |
| MVP & startup projects shipping fast | Native-only apps (use Swift/Kotlin for max performance) |
| B2B SaaS & admin dashboards | Complex long-running business logic (use dedicated backend) |
| Teams without dedicated backend developers | Legacy system integrations requiring custom middleware |
| Multi-platform apps (iOS, Android, Web) from one codebase | Extremely large datasets (millions of rows with complex analytics) |
| Complex auth flows (OAuth, magic links, OTP) | Game development (use Unity/Unreal) |

---

## 📦 Core Stack

### Backend: Supabase
- PostgreSQL database with Row Level Security
- Authentication (Email, OAuth, Magic Links)
- Real-time subscriptions
- Storage (file uploads)
- Edge Functions (serverless)

### Frontend: Flutter

- supabase_flutter   
- flutter_riverpod  
- go_router         
- freezed           
- flutter_dotenv    
- shadcn_ui         


---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.3+
- Supabase account (free tier works!)
- Docker (for local Supabase development)

### 1. Clone & Setup
```bash
git clone https://github.com/your-username/flutter-supabase-template
cd flutter-supabase-template

# Copy environment template
cp .env.example .env
```

### 2. Start Local Supabase
```bash
supabase start
```

### 3. Configure Frontend
Update `.env` with the credentials from `supabase start`:
```env
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=<anon-key-from-supabase-start>
WEB_REDIRECT_URL=http://localhost:5500/
```

### 4. Install & Generate
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run
```bash
# Web (important: use port 5500 for Supabase redirects)
flutter run -d chrome --web-port 5500
```

**[Detailed setup guide →](./docs/SETUP.md)**

---

## 📚 Documentation

- **[Setup Guide](./docs/SETUP.md)** – Detailed installation and configuration
- **[Architecture Overview](./docs/ARCHITECTURE.md)** – How everything fits together
- **[Frontend Guidelines](./guidelines/frontend.md)** – Flutter patterns & best practices
- **[Supabase Guidelines](./guidelines/supabase.md)** – Database, migrations, RLS

---

## 🤝 Contributing

Found a bug? Have a suggestion? PRs welcome!

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

MIT License – use this template however you want!

---

## 🙏 Acknowledgments

Built with:
- [Flutter](https://flutter.dev) – Cross-platform UI framework
- [Supabase](https://supabase.com) – Open-source Firebase alternative
- [Riverpod](https://riverpod.dev) – Reactive state management
- [GoRouter](https://pub.dev/packages/go_router) – Declarative routing
- [Freezed](https://pub.dev/packages/freezed) – Code generation for models

---

## 💬 Questions?

- **Issues?** Open an issue on GitHub
- **Discussions?** Start a discussion in the repo
- **Documentation?** Check the [`docs/`](./docs) folder

---

**Happy coding! 🚀**

*Remember: This template gives you the foundation. The magic is what you build on top.*
