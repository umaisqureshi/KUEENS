import 'package:flutter/foundation.dart';
class SomeValue {}

class ExtendedValue extends SomeValue {}

abstract class SomeController<T extends SomeValue> extends ValueNotifier<T> {
  SomeController(T value) : super(value);
}

class ExtendedController extends SomeController {
  ExtendedController(ExtendedValue value) : super(value);

  factory ExtendedController.create() {
    return ExtendedController(ExtendedValue());
  }
}

