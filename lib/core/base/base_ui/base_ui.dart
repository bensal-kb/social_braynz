import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../styles/theme.dart';
import '../../../dependencies/get_dependencies.dart';

export '../base_bloc/base_states.dart';
export 'package:flutter/material.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export '../../../dependencies/get_dependencies.dart';

extension BaseUI on BuildContext {
  Themes get theme => appTheme.currentTheme;

  void removeFocus() => FocusManager.instance.primaryFocus?.unfocus();

  GoRouter get router => GoRouter.of(this);

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}
