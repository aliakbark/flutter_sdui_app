# SDUI Package Test Suite - Core Tests Only

This directory contains essential tests for the core functionality of the SDUI (Server-Driven UI) package. The test suite focuses exclusively on the core business logic in `packages/sdui/lib/src/core/`.

## Test Structure

```
test/
├── helpers/
│   ├── mock_data.dart              # Mock data and configurations
│   └── test_utils.dart             # Test utilities and helpers
├── core/
│   ├── sdui_service_test.dart      # Service initialization and management
│   ├── sdui_parser_test.dart       # JSON parsing and configuration loading
│   ├── sdui_renderer_test.dart     # Widget rendering from configuration
│   └── workflow_controller_test.dart # Workflow state and navigation management
└── all_tests.dart                  # Test runner for all core tests
```

## Core Components Tested

### 1. SduiService (`sdui_service_test.dart`)
Tests the main service that orchestrates the SDUI system:
- ✅ Service initialization with different configuration sources
- ✅ Workflow management and retrieval
- ✅ Widget creation from configuration
- ✅ Error handling for uninitialized service
- ✅ Service lifecycle (reload, reset)

### 2. SduiParser (`sdui_parser_test.dart`)
Tests JSON parsing and configuration loading:
- ✅ Valid JSON configuration parsing
- ✅ Invalid JSON error handling
- ✅ Missing required fields validation
- ✅ Asset loading from bundle
- ✅ Network configuration loading
- ✅ Mock network configuration
- ✅ Comprehensive error scenarios

### 3. SduiRenderer (`sdui_renderer_test.dart`)
Tests widget rendering from configuration:
- ✅ All supported widget types (text, textfield, button, container, row, column, spacer, otpfield)
- ✅ Unsupported widget placeholder rendering
- ✅ Case-insensitive widget type handling
- ✅ Error handling during rendering
- ✅ Widget hierarchy rendering (containers with children)

### 4. SduiWorkflowController (`workflow_controller_test.dart`)
Tests workflow state management and navigation:
- ✅ Controller initialization with workflow
- ✅ Screen navigation and validation
- ✅ Form data management (update, retrieve, validation)
- ✅ Field validation (individual and screen-wide)
- ✅ Action execution (capability, navigate, toast, dialog)
- ✅ Loading state management
- ✅ Parameter resolution for actions
- ✅ Error handling and callbacks
- ✅ Workflow reset and completion

## Why Core Tests Only?

This focused approach provides several benefits:

### 1. **Essential Coverage**
- Tests the fundamental business logic that powers the entire SDUI system
- Covers the critical path from configuration loading to widget rendering
- Ensures the core architecture is solid and reliable

### 2. **Maintainability**
- Fewer tests to maintain when core APIs change
- Focused on testing behavior rather than implementation details
- Easier to understand and modify

### 3. **Performance**
- Faster test execution with focused test suite
- Quicker feedback during development
- Reduced CI/CD pipeline time

### 4. **Quality Focus**
- Each test covers critical functionality that must work
- Tests are comprehensive but not redundant
- Focus on user-facing functionality and error scenarios

## What's NOT Tested

The following areas are intentionally excluded to keep the test suite focused:

- ❌ Individual widget implementations (text field, button, container, etc.)
- ❌ Validation rule implementations
- ❌ Capability system details
- ❌ Exception class implementations
- ❌ Theme integration details
- ❌ UI interaction specifics

These components rely on the core functionality being tested and can be validated through integration testing or manual testing.

## Running Tests

### Run All Core Tests
```bash
flutter test test/all_tests.dart
```

### Run Individual Core Test Files
```bash
flutter test test/core/sdui_service_test.dart
flutter test test/core/sdui_parser_test.dart
flutter test test/core/sdui_renderer_test.dart
flutter test test/core/workflow_controller_test.dart
```

### Run All Tests in Core Directory
```bash
flutter test test/core/
```

## Test Coverage

### High Priority (Fully Covered):
- ✅ Service initialization and lifecycle management
- ✅ Configuration parsing and loading (JSON, assets, network)
- ✅ Widget rendering from configuration
- ✅ Workflow state management and navigation
- ✅ Form data handling and validation
- ✅ Action execution and parameter resolution
- ✅ Error handling and exception scenarios
- ✅ Loading states and callbacks

### Core Test Metrics:
- **4 core test files**
- **~60 focused tests**
- **Complete coverage of core business logic**
- **Fast execution (~2-3 seconds)**
- **Easy maintenance**

## Benefits of Core-Only Approach

1. **Laser Focus** - Tests only the essential functionality that everything else depends on
2. **High ROI** - Maximum test value with minimal maintenance overhead
3. **Fast Feedback** - Quick test execution provides rapid development feedback
4. **Reliability** - Ensures the foundation of the SDUI system is rock solid
5. **Simplicity** - Easy to understand, modify, and extend

## Integration Testing

While this test suite focuses on core functionality, integration testing should be performed to validate:
- End-to-end workflows
- Widget interactions
- Theme application
- Real network scenarios
- Device-specific behavior

The core tests provide confidence that the fundamental system works correctly, allowing integration tests to focus on user experience and edge cases.

## Philosophy

> "Test the core, trust the rest"

This test suite embodies the principle that if the core business logic is thoroughly tested and reliable, the rest of the system built on top of it will be more likely to work correctly. By focusing testing efforts on the most critical components, we achieve better overall system reliability with less maintenance overhead.
