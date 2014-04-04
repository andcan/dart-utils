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