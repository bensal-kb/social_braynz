import 'base_ui.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    super.key,
    this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.onRefresh,
    this.hasSafeArea = true,
    this.safeAreaBottom = false,
  });

  final Widget? child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Future<void> Function()? onRefresh;
  final bool hasSafeArea;
  final bool safeAreaBottom;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.removeFocus,
      child: Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor ?? context.theme.background,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        body: _safeAreaWrapper(
          child: _refreshWrapper(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }

  Widget _safeAreaWrapper({required Widget child}) {
    if (!hasSafeArea) return child;
    return SafeArea(bottom: safeAreaBottom, child: child);
  }

  Widget _refreshWrapper({required Widget child}) {
    if (onRefresh == null) return child;
    return RefreshIndicator(onRefresh: onRefresh!, child: child);
  }
}
