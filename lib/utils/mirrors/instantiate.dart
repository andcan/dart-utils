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
