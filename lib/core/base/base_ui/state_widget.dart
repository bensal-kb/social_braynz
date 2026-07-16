import 'base_ui.dart';
import 'widgets/default_error_widget.dart';
import 'widgets/default_loading_widget.dart';

typedef StateWidgetBuilder<S extends BaseState> = Widget Function(
  BuildContext context,
  S state,
);

class StateWidget<B extends StateStreamableSource<S>, S extends BaseState>
    extends StatelessWidget {
  const StateWidget({
    super.key,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.initialBuilder,
    this.retry,
  });

  final StateWidgetBuilder<S> builder;
  final StateWidgetBuilder<S>? loadingBuilder;
  final StateWidgetBuilder<S>? errorBuilder;
  final StateWidgetBuilder<S>? initialBuilder;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      listener: (context, state) {
        if (state.isError) {
          logger.e('$B error: ${state.error?.message ?? 'Unknown'}');
        }
      },
      builder: (context, state) {
        if (state.isInitial) {
          return initialBuilder?.call(context, state) ??
              const SizedBox.shrink();
        }
        if (state.isError) {
          return errorBuilder?.call(context, state) ??
              DefaultErrorWidget(state: state, retry: retry);
        }
        if (state.isLoading) {
          return loadingBuilder?.call(context, state) ??
              const DefaultLoadingWidget();
        }
        return builder(context, state);
      },
    );
  }
}
