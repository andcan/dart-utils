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
part of utils;

/**
 * Represents an optional value.
 */
class Optional<T> {
  /**
   * [:true:] if created with [Optional.absent], otherwise [:false:].
   */
  final bool _absent;
  /**
   * [value] of this [Optional]
   */
  final T value;
  /**
   * Creates a non-absent optional
   */
  Optional(this.value) :
    _absent = false;
  /**
   * Creates an absent optional
   */
  Optional.absent() :
    _absent = true,
    value = null;
  /**
   * [:true:] if created with [Optional.absent].
   */
  bool get isAbsent => _absent;
  /**
   * [:true:] if created with [Optional] default constructor.
   */
  bool get isNotAbsent => ! _absent;
  
  String toString () => isAbsent ? 'Absent Optional' : 'Optional of $value';
}