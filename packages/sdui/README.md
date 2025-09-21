# SDUI (Server-Driven UI) Package

A comprehensive Flutter package for building server-driven user interfaces with JSON configuration.

## Features

- 🎨 **Theme-driven UI**: Centralized theme tokens for consistent styling
- 🔄 **Workflow Management**: Multi-screen workflows with navigation
- ✅ **Form Validation**: Built-in validation system with multiple rule types
- 🔌 **Capability System**: Extensible system for external integrations
- 📱 **Widget Library**: Pre-built widgets (Text, TextField, Button, OTP, etc.)
- 🏗️ **SOLID Architecture**: Clean, testable, and extensible codebase

## Quick Start

### 1. Initialize SDUI Service

```dart
import 'package:sdui/sdui.dart';

// Initialize with asset configuration
await SduiService.initialize(
  assetPath: 'assets/json/dynamic_ui_config.json',
);

// Register capabilities
SduiService.registerCapabilities([
  MockAuthOtpSendCapability(),
  MockAuthOtpVerifyCapability(),
]);
```

### 2. Use SDUI Workflow Widget

```dart
// Navigate to a workflow
SduiService.navigateToWorkflow(
  context,
  'onboarding_v1',
  onComplete: () {
    print('Workflow completed!');
  },
  onError: (error) {
    print('Error: $error');
  },
);

// Or create a workflow widget directly
Widget workflowWidget = SduiService.createWorkflowWidget(
  workflowId: 'onboarding_v1',
  onComplete: () => Navigator.pop(context),
);
```

## JSON Configuration Structure

### Basic Structure

```json
{
  "app_version_min": "1.0.0",
  "theme_tokens": {
    "color.primary": "#0A84FF",
    "color.bg": "#FFFFFF",
    "color.text": "#111827",
    "radius.md": 12,
    "space.sm": 8,
    "space.md": 16,
    "font.family": "SF Pro"
  },
  "workflows": [
    {
      "id": "workflow_id",
      "start_screen": "screen_id",
      "screens": [...]
    }
  ]
}
```

### Screen Configuration

```json
{
  "id": "register_phone",
  "title": "Create your account",
  "widgets": [
    {
      "type": "Text",
      "props": {
        "text": "Enter your mobile to get started.",
        "style": "title"
      }
    },
    {
      "type": "TextField",
      "id": "phone",
      "label": "Mobile number",
      "props": {
        "keyboard": "phone",
        "hint": "+971 5x xxx xxxx"
      },
      "validators": [
        {
          "type": "required",
          "message": "Phone is required"
        }
      ]
    }
  ]
}
```

## Supported Widgets

### Text Widget
```json
{
  "type": "Text",
  "props": {
    "text": "Hello World",
    "style": "title|subtitle|caption",
    "align": "left|center|right|justify"
  }
}
```

### TextField Widget
```json
{
  "type": "TextField",
  "id": "field_id",
  "label": "Field Label",
  "props": {
    "keyboard": "text|phone|email|number",
    "hint": "Placeholder text",
    "maxLength": 50,
    "obscureText": false
  },
  "validators": [...]
}
```

### Button Widget
```json
{
  "type": "Button",
  "label": "Button Text",
  "style": "primary|secondary|text",
  "props": {
    "fullWidth": true
  },
  "action": {
    "type": "capability.invoke",
    "capability": "capability_name",
    "params": {...}
  }
}
```

### OTP Field Widget
```json
{
  "type": "OtpField",
  "id": "otp",
  "label": "6-digit code",
  "props": {
    "length": 6
  },
  "validators": [...]
}
```

### Layout Widgets
```json
{
  "type": "Row",
  "props": {
    "spacing": 16,
    "mainAxisAlignment": "start|end|center|spaceBetween",
    "crossAxisAlignment": "start|end|center|stretch"
  },
  "children": [...]
}
```

```json
{
  "type": "Column",
  "props": {
    "spacing": 16,
    "mainAxisAlignment": "start|end|center|spaceBetween",
    "crossAxisAlignment": "start|end|center|stretch"
  },
  "children": [...]
}
```

## Validation System

### Supported Validators

```json
{
  "validators": [
    {
      "type": "required",
      "message": "This field is required"
    },
    {
      "type": "regex",
      "pattern": "^\\+?[0-9]{9,15}$",
      "message": "Invalid format"
    },
    {
      "type": "length",
      "min": 6,
      "max": 10,
      "message": "Must be 6-10 characters"
    },
    {
      "type": "email",
      "message": "Invalid email address"
    },
    {
      "type": "phone",
      "message": "Invalid phone number"
    }
  ]
}
```

## Capability System

### Creating Custom Capabilities

```dart
class CustomCapability implements SduiCapability {
  @override
  String get name => 'custom-capability-v1';

  @override
  Future<SduiCapabilityResult> execute(Map<String, dynamic> params) async {
    try {
      // Your custom logic here
      final result = await performCustomAction(params);
      
      return SduiCapabilityResult.success(
        message: 'Action completed successfully',
        data: result,
      );
    } catch (e) {
      return SduiCapabilityResult.error('Action failed: $e');
    }
  }
}

// Register the capability
SduiService.registerCapabilities([
  CustomCapability(),
]);
```

### Using Capabilities in Actions

```json
{
  "type": "Button",
  "label": "Execute Action",
  "action": {
    "type": "capability.invoke",
    "capability": "custom-capability-v1",
    "params": {
      "param1": "value1",
      "field_ref": "field_id"
    },
    "on_success": {
      "navigate": "next_screen",
      "show_toast": "Success message"
    },
    "on_error": {
      "show_toast": "Error message",
      "show_dialog": {
        "title": "Error",
        "body": "Something went wrong"
      }
    }
  }
}
```

## Action Types

### Navigation Actions
```json
{
  "action": {
    "type": "navigate",
    "screen": "target_screen_id"
  }
}
```

### Capability Actions
```json
{
  "action": {
    "type": "capability.invoke",
    "capability": "capability_name",
    "params": {...},
    "on_success": {...},
    "on_error": {...}
  }
}
```

### UI Actions
```json
{
  "action": {
    "type": "show_toast",
    "message": "Toast message"
  }
}
```

```json
{
  "action": {
    "type": "show_dialog",
    "title": "Dialog Title",
    "body": "Dialog content"
  }
}
```

## Architecture

The SDUI package follows SOLID principles with a clean architecture:

```
lib/
├── src/
│   ├── models/          # Data models with JSON serialization
│   ├── core/            # Core business logic
│   │   ├── sdui_parser.dart
│   │   ├── sdui_renderer.dart
│   │   ├── workflow_controller.dart
│   │   └── sdui_service.dart
│   ├── widgets/         # UI widget implementations
│   ├── capabilities/    # Capability system
│   ├── validation/      # Form validation
│   └── exceptions/      # Custom exceptions
└── sdui.dart           # Main export file
```

## Testing

The package is designed to be highly testable:

```dart
// Test workflow controller
final controller = SduiWorkflowController(
  workflow: mockWorkflow,
  onComplete: () {},
  onError: (error) {},
);

// Test field validation
final error = FieldValidator.validate('test@email.com', [
  ValidationRule(type: 'email', message: 'Invalid email'),
]);

// Test capabilities
final result = await MockAuthOtpSendCapability().execute({
  'phone': '+1234567890',
});
```

## Contributing

1. Follow the existing code style and architecture
2. Add tests for new features
3. Update documentation
4. Ensure all widgets are properly integrated with the renderer

## License

This package is part of the Flutter SDUI Demo App project.
