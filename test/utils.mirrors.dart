import '../lib/mirror.dart';

import 'dart:mirrors';

import 'package:unittest/unittest.dart';

class A {
  
}

void main () {
  test('utils/mirrors/symbol.dart', () {
    Symbol a = new Symbol('asd');
    //testing cache
    cache(a);
    expect(a, equals(symbol('asd')));
    //testing auto-creation on missing symbol
    expect(new Symbol('test'), equals(symbol('test')));
  });
  test('utils/mirrors/instantiate.dart', () {
    //Creating a VERY empty class without supplying constructor name
    InstanceMirror mirror = instantiate(reflectClass(A), <Symbol, dynamic>{});
    expect (mirror.reflectee, isNotNull);
    //Creating a VERY empty class supplying constructor name
    mirror = instantiate(reflectClass(A), <Symbol, dynamic>{},
        constructorName: new Symbol(''));
    expect (mirror.reflectee, isNotNull);
    //Same as above
    mirror = newInstance(symbol('A'), <Symbol, dynamic>{}, constructorName: symbol(''));
    expect (mirror.reflectee, isNotNull);
  });
}