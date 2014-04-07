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
 * Returns true if and only if argument is a [MethodMirror] on a constructor and 
 * it isn't const or private
 */
final Function IS_NON_CONST_CONSTRUCTOR = (DeclarationMirror declaration) 
    => declaration is MethodMirror && declaration.isConstructor
        && ! declaration.isPrivate && ! declaration.isConstConstructor;//impossible to instatiate const objects at runtime
/**
 * Result of [apply] function
 */
class ApplyResult {
  final Map<Symbol, dynamic> named;
  final List positional;
  
  ApplyResult(List this.positional, {Map<Symbol, dynamic> this.named});
}
/**
 * Applies [args] to [method] arguments. More [args] than necessary are 
 * discarded. If a required argument is missing an [ArgumentError] is thrown.
 */
ApplyResult apply (MethodMirror method, Map<Symbol, dynamic> args) {
  List positional = [];
  Map<Symbol, dynamic> named = <Symbol, dynamic>{};
  
  method.parameters.forEach((param) {
    Symbol name = param.simpleName;
    if (! args.containsKey(name)) {
      if (! param.isOptional) {
        throw new ArgumentError('Missing required parameter ${MirrorSystem.getName(param.simpleName)}');
      }/*else {
        //Nothing to do: param is not required
      }*/
    } else {
      if (! param.isNamed) {
        positional.add(args[name]);
      } else {
        named[name] = args[name];
      }
    }
  });
  
  return new ApplyResult(positional, named: named);
}

Map<ClassMirror, Iterable<DeclarationMirror>> constructors = <ClassMirror, 
  Iterable<DeclarationMirror>>{};

InstanceMirror instantiate (ClassMirror mirror, Map<Symbol, dynamic> args, 
                            {Symbol constructorName}) {
  ApplyResult result;
  if (null == constructorName) {
    Iterable<DeclarationMirror> cs;
    if (constructors.containsKey(mirror)) {
      cs = constructors[mirror];
    } else {
      cs = constructors[mirror] = 
          mirror.declarations.values.where(IS_NON_CONST_CONSTRUCTOR);
    }
    if (cs.isEmpty) {
      //Maybe there aren't any suitable constructor
      result = new ApplyResult([]);
    }
    for (MethodMirror method in cs){
      try {
        result = apply(method, args);
        constructorName = method.constructorName;
        break;
      } on ArgumentError {
        //Not appliable
      }
    }
  } else {
    DeclarationMirror c = "" == MirrorSystem.getName(constructorName) 
        ? mirror.declarations.values.where((test) 
            => IS_NON_CONST_CONSTRUCTOR(test) 
            && (test as MethodMirror).constructorName == constructorName).first
        : mirror.declarations[constructorName];
    if (c is MethodMirror) {
      result = apply(c, args);
    } else {
      throw new ArgumentError('${MirrorSystem.getName(constructorName)} is not a MethodMirror');
    }
  }
  return mirror.newInstance(constructorName, result.positional, result.named);
}