part of 'base_workflow_cubit.dart';

/// Base class for all SDUI workflow states
abstract class BaseWorkflowState extends Equatable {
  const BaseWorkflowState();

  @override
  List<Object?> get props => [];
}

/// Initial state when workflow starts
class WorkflowInitial extends BaseWorkflowState {
  const WorkflowInitial();
}

/// Loading state during workflow operations
class WorkflowLoading extends BaseWorkflowState {
  const WorkflowLoading();
}

/// Success state with optional data
class WorkflowSuccess extends BaseWorkflowState {
  final Map<String, dynamic>? data;

  const WorkflowSuccess({this.data});

  @override
  List<Object?> get props => [data];
}

/// Error state with error message
class WorkflowError extends BaseWorkflowState {
  final String message;

  const WorkflowError(this.message);

  @override
  List<Object?> get props => [message];
}
