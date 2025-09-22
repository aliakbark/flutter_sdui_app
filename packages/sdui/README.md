# SDUI - Server-Driven UI for Flutter

A Flutter package that enables dynamic UI rendering based on JSON configurations from servers or assets.

## Package Structure

```
lib/
├── src/
│   ├── core/          # Parser, Renderer, Service, Workflow Controller
│   ├── models/        # Data models (Config, Workflow, Widget, Theme)
│   ├── widgets/       # Pre-built SDUI widgets
│   ├── capabilities/  # Extensible functionality system
│   ├── validation/    # Field validation
│   └── utils/         # Helper utilities
├── assets/
│   ├── json/          # Example configurations
│   └── config/        # Default configs
└── example/           # Sample implementation
```

## Core Functionalities

### Parser
Converts JSON configurations to Dart objects. Supports loading from:
- Assets (`loadFromAsset`)
- Network APIs (`loadFromNetwork`) 
- Direct JSON (`parseFromJson`)

### Renderer
Maps widget configurations to Flutter widgets using a switch-case system. Handles unsupported widgets with error placeholders.

### Workflow Controller
Manages workflow state using `ChangeNotifier`:
- Form data and validation
- Screen navigation
- Action execution with parameter resolution
- Loading states

### Service
High-level API providing:
- Configuration initialization
- Workflow management
- Widget/page creation helpers
- Navigation utilities

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  sdui:
    path: packages/sdui
```

## Integration Steps

### 1. Initialize Service

```dart
import 'package:sdui/sdui.dart';

// From asset
await SduiService.initialize(assetPath: 'assets/config.json');

// From network
await SduiService.initialize(networkUrl: 'https://api.example.com/config');

// Direct config
await SduiService.initialize(config: myConfig);
```

### 2. Register Capabilities (Optional)

```dart
SduiService.registerCapabilities([
  MyCustomCapability(),
  ApiCallCapability(),
]);
```

### 3. Use Workflow Widgets

```dart
// As widget
SduiService.createWorkflowWidget(
  workflowId: 'user_onboarding',
  onComplete: () => print('Workflow completed'),
  onError: (error) => print('Error: $error'),
)

// As full page
SduiService.createWorkflowPage(
  workflowId: 'user_onboarding',
  onComplete: () => Navigator.pop(context),
)

// Navigate to workflow
SduiService.navigateToWorkflow(context, 'user_onboarding');
```

## JSON Configuration Example

```json
{
  "app_version_min": "1.0.0",
  "theme_tokens": {
    "color.primary": "#007AFF",
    "color.bg": "#FFFFFF",
    "space.md": 16.0
  },
  "workflows": [
    {
      "id": "login_flow",
      "start_screen": "login_screen",
      "screens": [
        {
          "id": "login_screen",
          "title": "Login",
          "widgets": [
            {
              "id": "email_field",
              "type": "textfield",
              "properties": {
                "label": "Email",
                "hint": "Enter your email"
              },
              "validators": [
                {"type": "required", "message": "Email is required"},
                {"type": "email", "message": "Invalid email"}
              ]
            },
            {
              "id": "login_button",
              "type": "button",
              "properties": {
                "text": "Login"
              },
              "action": {
                "type": "capability.invoke",
                "capability": "authenticate",
                "params": {
                  "email_ref": "email_field"
                }
              }
            }
          ]
        }
      ]
    }
  ]
}
```

## Available Widgets

- `text` - Display text with styling
- `textfield` - Input field with validation
- `button` - Clickable button with actions
- `row` - Horizontal layout
- `column` - Vertical layout
- `container` - Styled container
- `spacer` - Empty space
- `otpfield` - OTP input field

## Adding New Widget Support

### 1. Create Widget Class

```dart
class SduiMyWidget extends StatelessWidget {
  final WidgetConfig config;
  final ThemeTokens themeTokens;
  final SduiWorkflowController? controller;

  const SduiMyWidget({
    Key? key,
    required this.config,
    required this.themeTokens,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final properties = config.properties as Map<String, dynamic>? ?? {};
    // Extract properties and build widget
    return YourFlutterWidget();
  }
}
```

### 2. Register in Renderer

Add to `SduiRenderer.renderWidget()` switch statement:

```dart
case 'mywidget':
  return SduiMyWidget(
    config: config,
    themeTokens: themeTokens,
    controller: controller,
  );
```

### 3. Export in Main Library

Add to `lib/sdui.dart`:

```dart
export 'src/widgets/sdui_my_widget.dart';
```

### 4. Use in JSON

```json
{
  "id": "my_widget_instance",
  "type": "mywidget",
  "properties": {
    "customProperty": "value"
  }
}
```

## Creating Custom Capabilities

```dart
class MyCapability extends SduiCapability {
  @override
  String get name => 'my_capability';

  @override
  Future<SduiCapabilityResult> execute(Map<String, dynamic> params) async {
    try {
      // Your custom logic here
      return SduiCapabilityResult.success('Operation completed');
    } catch (e) {
      return SduiCapabilityResult.failure('Operation failed: $e');
    }
  }
}
```

## API Reference

### SduiService
- `initialize()` - Initialize with configuration
- `createWorkflowWidget()` - Create workflow widget
- `createWorkflowPage()` - Create full-page workflow
- `navigateToWorkflow()` - Navigate to workflow
- `getWorkflow()` - Get workflow by ID

### SduiWorkflowController
- `navigateToScreen()` - Navigate within workflow
- `updateField()` - Update form field
- `validateCurrentScreen()` - Validate all fields
- `executeAction()` - Execute widget actions

## License

This project is licensed under the MIT License.
