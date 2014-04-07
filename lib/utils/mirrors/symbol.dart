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