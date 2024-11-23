# leontech

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

lib/
  ├── core/                      # Core functionalities and utilities
  │   ├── models/                # Data models and entities
  │   ├── services/              # Network requests, data access, etc.
  │   ├── widgets/               # Reusable UI components
  │   └── utils/                 # Helper functions, constants, etc.
  ├── features/                  # Feature-specific directories
  │   ├── auth/                  # Authentication feature
  │   │   ├── data/             # Data layer for authentication
  │   │   ├── domain/           # Business logic for authentication
  │   │   ├── presentation/      # UI components for authentication
  │   │   └── models/            # Models specific to authentication
  │   ├── home/                  # Home screen feature
  │   │   ├── ...               # Similar structure as auth/
  │   └── ...                   # Other features
  ├── main.dart                  # Entry point of the application
  ├── routes.dart                 # App navigation and routing logic
  └── theme.dart                 # App-wide styling and theming
