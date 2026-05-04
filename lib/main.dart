import '/ui/styles/theme.dart';

import 'ui/simulacao.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Anotações',
      theme: AppTheme.appTheme,
      home: Simulacao(),
    ),
  );
}
