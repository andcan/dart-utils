part of utils.mirrors;

/**
 * Caches [Symbol] instances keyed by their value for later use without recreation
 */
class _SymbolCache implements Function {
  /**
   * [Symbol] cache
   */
  final Map<String, Symbol> symbols = <String, Symbol>{};
  /**
   * Returns cached [Symbol] instance or creates a new one to return
   */
  Symbol call (String value) 
    => symbols.containsKey(value) ? symbols[value]
      : symbols[value] = new Symbol(value);
  
  static apply(Function function, List positionalArguments,
      [Map<Symbol, dynamic> namedArguments]) {
    if (1 != positionalArguments.length) {
      throw new ArgumentError('Bad positionalArguments length: ${positionalArguments.length}');
    }
    final value = positionalArguments.first;
    if (value is! String) {
      throw new ArgumentError('value is not String. Found ${value.runtimeType}');
    }
    return function(value);
  }
}

final _SymbolCache _cache = new _SymbolCache();

Symbol cache (Symbol s) => _cache.symbols[MirrorSystem.getName(s)] = s;

Symbol symbol (String value) => _cache(value);