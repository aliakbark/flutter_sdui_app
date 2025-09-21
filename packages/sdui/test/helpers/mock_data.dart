import 'package:sdui/src/models/sdui_config.dart';
import 'package:sdui/src/models/theme_tokens.dart';
import 'package:sdui/src/models/workflow.dart';
import 'package:sdui/src/models/widget_config.dart';
import 'package:sdui/src/models/action_config.dart';

class MockData {
  /// Theme tokens used across multiple tests for consistent theming
  static const ThemeTokens mockThemeTokens = ThemeTokens(
    colorPrimary: '#007AFF',
    colorBg: '#FFFFFF',
    colorText: '#000000',
    radiusMd: 8.0,
    spaceSm: 8.0,
    spaceMd: 16.0,
    fontFamily: 'SF Pro Display',
  );

  /// Complete workflow used in workflow controller tests
  static const Workflow mockWorkflow = Workflow(
    id: 'user_onboarding',
    startScreen: 'welcome_screen',
    screens: [
      SduiScreen(
        id: 'welcome_screen',
        title: 'Welcome',
        widgets: [
          WidgetConfig(
            id: 'welcome_text',
            type: 'text',
            label: 'Welcome to our app!',
          ),
          WidgetConfig(
            id: 'continue_button',
            type: 'button',
            label: 'Continue',
            action: ActionConfig(
              type: 'navigate',
              capability: 'registration_screen',
            ),
          ),
        ],
      ),
      SduiScreen(
        id: 'registration_screen',
        title: 'Registration',
        widgets: [
          WidgetConfig(
            id: 'name_field',
            type: 'text_field',
            label: 'Full Name',
            validators: [
              ValidationRule(type: 'required', message: 'Name is required'),
            ],
          ),
          WidgetConfig(
            id: 'email_field',
            type: 'text_field',
            label: 'Email',
            validators: [
              ValidationRule(type: 'required', message: 'Email is required'),
              ValidationRule(type: 'email', message: 'Invalid email format'),
            ],
          ),
        ],
      ),
      SduiScreen(
        id: 'form_screen',
        title: 'Form',
        widgets: [
          WidgetConfig(
            id: 'name_field',
            type: 'text_field',
            label: 'Full Name',
            validators: [
              ValidationRule(type: 'required', message: 'Name is required'),
            ],
          ),
          WidgetConfig(
            id: 'email_field',
            type: 'text_field',
            label: 'Email',
            validators: [
              ValidationRule(type: 'required', message: 'Email is required'),
              ValidationRule(type: 'email', message: 'Invalid email format'),
            ],
          ),
        ],
      ),
    ],
  );

  /// Complete SDUI configuration used in service tests
  static SduiConfig get mockSduiConfig => SduiConfig(
    appVersionMin: '1.0.0',
    themeTokens: mockThemeTokens,
    workflows: [mockWorkflow],
  );

  /// JSON configuration used in parser tests
  static Map<String, dynamic> get mockConfigJson => {
    'app_version_min': '1.0.0',
    'theme_tokens': {
      'color.primary': '#007AFF',
      'color.bg': '#FFFFFF',
      'color.text': '#000000',
      'radius.md': 8.0,
      'space.sm': 8.0,
      'space.md': 16.0,
      'font.family': 'SF Pro Display',
    },
    'workflows': [
      {
        'id': 'user_onboarding',
        'start_screen': 'welcome_screen',
        'screens': [
          {
            'id': 'welcome_screen',
            'title': 'Welcome',
            'widgets': [
              {
                'id': 'welcome_text',
                'type': 'text',
                'label': 'Welcome to our app!',
              },
            ],
          },
        ],
      },
    ],
  };
}
