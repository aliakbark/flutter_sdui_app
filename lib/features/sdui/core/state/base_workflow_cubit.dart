import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'base_workflow_state.dart';

/// Base cubit for all SDUI workflows
/// Provides common state management methods with type safety
abstract class BaseWorkflowCubit extends Cubit<BaseWorkflowState> {
  BaseWorkflowCubit() : super(const WorkflowInitial());

  /// Set workflow to loading state
  void setLoading() {
    emit(const WorkflowLoading());
  }

  /// Set workflow to error state with message
  void setError(String message) {
    emit(WorkflowError(message));
  }

  /// Set workflow to success state with optional data
  void setSuccess({Map<String, dynamic>? data}) {
    emit(WorkflowSuccess(data: data));
  }

  /// Reset to initial state
  void reset() {
    emit(const WorkflowInitial());
  }

  /// Check if the current state is loading
  bool get isLoading => state is WorkflowLoading;

  /// Check if the current state is success
  bool get isSuccess => state is WorkflowSuccess;

  /// Check if the current state is an error
  bool get isError => state is WorkflowError;

  /// Get error message if the current state is an error
  String? get errorMessage {
    final currentState = state;
    return currentState is WorkflowError ? currentState.message : null;
  }

  /// Get success data if the current state is success
  Map<String, dynamic>? get successData {
    final currentState = state;
    return currentState is WorkflowSuccess ? currentState.data : null;
  }
}
