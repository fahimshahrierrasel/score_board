import 'package:flutter/material.dart';

final generalCardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(5.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      offset: Offset(0, 3.0),
      blurRadius: 6,
    ),
  ],
);

final scoreControlDecoration = BoxDecoration(
  color: Color(0xffd8d8d8),
  borderRadius: BorderRadius.circular(5.0),
);
