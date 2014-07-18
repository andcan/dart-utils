part of utils;
/**
 * Creates a generic [Pair]
 */
class Pair<T, U> {
  /**
   * [first] element
   */
  final T first;
  /**
   * [second] element
   */
  final U second;
  /**
   * Creates a [Pair] with [first] and [second]
   */
  Pair (T this.first, U this.second);
}