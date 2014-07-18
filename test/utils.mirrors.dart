/**
 * Copyright (C) 2014  Andrea Cantafio kk4r.1m@gmail.com
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
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