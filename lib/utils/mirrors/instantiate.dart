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
part of utils.mirrors;

/**
 * Reference to current [MirrorSystem]
 */
final MirrorSystem CURRENT_MIRROR_SYSTEM = currentMirrorSystem();

/**
 * Creates a new instance of [className] in [libraryName] passing [args] to 
 * [constructorName].
 * If [constructorName] is not provided a suitable one will be searched.
 * If [libraryName] is not provided a suitable one will be searched.
 * [values] are used to set remaining fields
 */
InstanceMirror newInstance (Symbol className, Map<Symbol, dynamic> args, 
                            {Symbol constructorName, Symbol libraryName, 
                              Map<Symbol, dynamic> values}) {
  LibraryMirror library;
    
  if (null == libraryName) {
    //Trying to find a library
    Iterable<LibraryMirror> libs = CURRENT_MIRROR_SYSTEM.libraries.values
        .where((test) => test.declarations.containsKey(className));
    switch (libs.length) {
      case 0:
        throw new ArgumentError('Declaration not found');
        break;
      case 1:
        library = libs.first;
        break;
      default:
        throw new ArgumentError('Too many declarations');
        break;
    }
  } else {
    try {
      library = CURRENT_MIRROR_SYSTEM.findLibrary(libraryName);
    } on Error catch (e) {
      throw new ArgumentError('Library not found');
    }
  }
  final declarations = library.declarations;
  var m = declarations[className];
  if (m is! ClassMirror) {
    throw new ArgumentError('$m is not a ClassMirror');
  }
  InstanceMirror instance = instantiate(m, args, 
      constructorName: constructorName);
  if (null != values) {
    values.forEach((name, value) => instance.setField(name, value));
  }
  return instance;
}
