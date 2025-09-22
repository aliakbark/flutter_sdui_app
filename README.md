# Flutter SDUI Demo App

A Flutter application demonstrating server-driven UI capabilities with clean architecture. This app showcases both traditional Flutter UI and dynamic SDUI workflows, allowing UI components to be configured and updated from server responses without app releases.

## 🚀 Getting Started

### Prerequisites

Ensure you have Flutter installed and configured:

```bash
# Ensure Flutter is on stable channel
flutter channel stable
flutter upgrade

# Verify Flutter version (>=3.35.0 required)
flutter --version
flutter doctor
```

**Required versions:**
- Flutter SDK: >=3.35.0
- Dart SDK: >=3.9.0 <4.0.0

### Installation

```bash
# Clone the repository
git clone https://github.com/aliakbark/flutter_sdui_app.git
cd flutter_sdui_app

# Install dependencies
flutter pub get

# Generate code (for JSON serialization)
dart run build_runner build

# Run the app
flutter run
```

## 🤖 DeepWiki Integration

**Interactive AI-powered documentation available at:**
https://deepwiki.com/aliakbark/flutter_sdui_app

DeepWiki is an AI-powered platform by Cognition that provides:
- **Natural language Q&A** about the codebase
- **Project architecture analysis** and explanations
- **Technology stack breakdown**
- **Interactive code exploration**

Perfect for anyone trying to understand or navigate this project - you can ask DeepWiki specific questions about the implementation, architecture decisions, or how different components work together.

## Key Features

- **Server-Driven UI (SDUI)** - Dynamic UI rendering from JSON configurations
- **Clean Architecture** - Feature-based organization with clear separation of concerns
- **BLoC State Management** - Predictable state management with flutter_bloc
- **Dependency Injection** - Service locator pattern with GetIt
- **Authentication System** - User authentication with local storage
- **Network Monitoring** - Connectivity status with user feedback
- **Error Handling** - Centralized error management system
- **Internationalization** - Multi-language support (English/Arabic)

## Architecture Overview

This app follows **Clean Architecture** principles with feature-based organization:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │     Domain      │    │      Data       │
│                 │    │                 │    │                 │
│ • Pages/Widgets │◄──►│ • Repositories  │◄──►│ • Data Sources  │
│ • BLoC/Cubit    │    │ • Use Cases     │    │ • Models        │
│ • States        │    │ • Entities      │    │ • API Clients   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

**Core Principles:**
- **Dependency Inversion** - High-level modules don't depend on low-level modules
- **Single Responsibility** - Each class has one reason to change
- **Feature Isolation** - Features are self-contained and independent

## Project Structure

```
lib/
├── core/                           # Shared core functionality
│   ├── constants/                  # App constants and asset paths
│   ├── di/                        # Dependency injection setup
│   ├── enums/                     # Shared enumerations
│   ├── errors/                    # Error handling and exceptions
│   ├── network/                   # API client and endpoints
│   └── shared/                    # Shared components
│       ├── data/                  # Base repositories and data sources
│       ├── presentation/          # Shared widgets and pages
│       ├── services/              # Core services (language, network, etc.)
│       └── states/                # App-level state management
├── features/                      # Feature modules
│   ├── auth/                      # Authentication feature
│   │   ├── data/                  # Auth data layer
│   │   ├── domain/                # Auth business logic
│   │   └── presentation/          # Auth UI components
│   ├── onboarding/                # Traditional onboarding flow
│   │   ├── data/                  # Onboarding data layer
│   │   ├── domain/                # Onboarding business logic
│   │   └── presentation/          # Onboarding UI components
│   ├── home/                      # Main app screen
│   └── sdui/                      # SDUI-specific implementations
│       ├── core/                  # SDUI workflow registry
│       ├── services/              # SDUI-related services
│       └── workflows/             # Specific workflow implementations
├── l10n/                          # Internationalization files
└── packages/                      # Local packages
    └── sdui/                      # SDUI core package
```

## SDUI Integration

### Configuration Loading

**Current Demo Setup:**
- Loads from assets: `assets/json/dynamic_ui_config.json`
- Demonstrates local SDUI configuration

**Production Scenario:**
```dart
// Fetch configuration from API
final response = await apiClient.get('/api/sdui/config');
final config = SduiConfig.fromJson(response.data);
await SduiService.initialize(config: config);
```

**Flexible Initialization Options:**
```dart
// From asset
await SduiService.initialize(assetPath: 'assets/config.json');

// From network
await SduiService.initialize(networkUrl: 'https://api.example.com/config');

// Direct config object
await SduiService.initialize(config: configObject);
```

### Adding New Workflows

**1. Create Workflow Class**
```dart
// lib/features/sdui/workflows/my_workflow/my_workflow.dart
class MyWorkflow {
  static const String id = 'my_workflow';
  
  static void registerCapabilities() {
    SduiService.registerCapabilities([
      MyCustomCapability(),
      AnotherCapability(),
    ]);
  }
}
```

**2. Create Custom Capabilities**
```dart
class MyCustomCapability extends SduiCapability {
  @override
  String get name => 'my_custom_action';
  
  @override
  Future<SduiCapabilityResult> execute(Map<String, dynamic> params) async {
    try {
      // Integrate with existing app services
      final result = await sl<MyService>().performAction(params);
      return SduiCapabilityResult.success('Action completed');
    } catch (e) {
      return SduiCapabilityResult.failure('Action failed: $e');
    }
  }
}
```

**3. Register in Workflow Registry**
```dart
// lib/features/sdui/core/sdui_workflow_registry.dart
static final Map<String, Function> _workflowCapabilities = {
  OnboardingWorkflow.id: OnboardingWorkflow.registerCapabilities,
  MyWorkflow.id: MyWorkflow.registerCapabilities, // Add this line
};
```

**4. Add to JSON Configuration**
```json
{
  "workflows": [
    {
      "id": "my_workflow",
      "start_screen": "welcome_screen",
      "screens": [
        {
          "id": "welcome_screen",
          "widgets": [
            {
              "type": "button",
              "action": {
                "type": "capability.invoke",
                "capability": "my_custom_action"
              }
            }
          ]
        }
      ]
    }
  ]
}
```

### Workflow Registry Pattern

The `SDUIWorkflowRegistry` automatically:
- Initializes SDUI service with configuration
- Registers capabilities only for workflows present in the loaded config
- Provides centralized workflow management
- Supports both asset and network-based configurations

## Development Guide

### Adding New Features

1. **Create Feature Directory** following the established structure
2. **Implement Clean Architecture** layers (data, domain, presentation)
3. **Add Dependency Injection** in `core/di/injector.dart`
4. **Create BLoC/Cubit** for state management
5. **Add Tests** for all layers
6. **Update Navigation** if needed

### Code Conventions

- Use **feature-first** organization
- Follow **Clean Architecture** principles
- Implement **BLoC pattern** for state management
- Add **comprehensive tests** for business logic
- Use **dependency injection** for service management
- Follow **Flutter/Dart** style guidelines

### SDUI Best Practices

- **Capability Naming**: Use descriptive, action-oriented names
- **Error Handling**: Always return appropriate `SduiCapabilityResult`
- **Service Integration**: Leverage existing app services in capabilities
- **Configuration Validation**: Validate JSON configurations thoroughly
- **Testing**: Test both traditional and SDUI workflows

## Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/auth_test.dart

# Run integration tests
flutter test integration_test/
```

**Test Structure:**
- **Unit Tests**: Business logic and utilities
- **Widget Tests**: UI components and interactions
- **Integration Tests**: End-to-end workflows
- **SDUI Tests**: Workflow and capability testing

## 🤝 Contributing

We welcome contributions! Please follow these steps:

### 1. Fork the Repository
Click the "Fork" button on the GitHub repository page.

### 2. Create a Feature Branch
```bash
git checkout -b feature/my-awesome-feature
```

**Branch Naming Conventions:**
- `feature/` - New features
- `bugfix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring

### 3. Make Your Changes
- Follow the existing code style and architecture
- Add tests for new functionality
- Update documentation if needed
- Ensure all tests pass

### 4. Commit Your Changes
```bash
git add .
git commit -m "feat: add awesome new feature"
```

**Commit Message Format:**
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `test:` - Adding tests
- `refactor:` - Code refactoring

### 5. Push to Your Fork
```bash
git push origin feature/my-awesome-feature
```

### 6. Create a Pull Request
- Go to your fork on GitHub
- Click "New Pull Request"
- Provide a clear description of your changes
- Reference any related issues

### Code Review Process
1. **Automated Checks** - CI/CD pipeline runs tests
2. **Code Review** - Maintainers review the code
3. **Feedback** - Address any requested changes
4. **Merge** - Once approved, changes are merged

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Happy Coding! 🚀**

For questions or support, please check the [DeepWiki documentation](https://deepwiki.com/aliakbark/flutter_sdui_app) or open an issue on GitHub.
