/// An exception to indicate cache operation failures.
final class JsonCacheException<T extends Object> implements Exception {
  /// Sets [extra] as the aditional information and [exception] as the original
  /// exception.
  const JsonCacheException({required this.extra, this.exception});

  /// Additional information about cache operation failure.
  ///
  /// Its `toString` method will be part of this exception's error message.
  final T extra;

  /// The original exception that indicated the failure of the caching
  /// operation.
  final Object? exception;

  /// Returns [extra] along with the original exception message.
  @override
  String toString() =>
      'JsonCacheException: $extra$_separator$_originalExceptionMessage';

  /// Returns '\n' if [exception] is set; otherwise, the empty string ''.
  String get _separator => exception != null ? '\n' : '';

  /// Returns the exception message if [exception] is set; otherwise, the empty
  /// string ''.
  String get _originalExceptionMessage => exception?.toString() ?? '';
}
