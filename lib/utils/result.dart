sealed class Result<T> {
  const Result();

  factory Result.ok(T value) => Ok(value);
  factory Result.error(Exception error) => Error(error);

  R fold<R>(R Function(Error<T>) onError, R Function(Ok<T>) onOk);
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
  @override
  R fold<R>(R Function(Error<T>) onError, R Function(Ok<T>) onOk) {
    return onOk(this);
  }
}

final class Error<T> extends Result<T> {
  const Error(this.error);

  final Exception error;
  @override
  R fold<R>(R Function(Error<T>) onError, R Function(Ok<T>) onOk) {
    return onError(this);
  }
}