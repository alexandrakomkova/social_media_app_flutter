sealed class Result<T> {
  const Result();

  factory Result.ok(T value) => Ok(value);

  factory Result.error(Exception error) => Failure(error);

  R fold<R>(R Function(Failure<T>) onError, R Function(Ok<T>) onOk);
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;

  @override
  R fold<R>(R Function(Failure<T>) onError, R Function(Ok<T>) onOk) {
    return onOk(this);
  }
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final Exception error;

  @override
  R fold<R>(R Function(Failure<T>) onError, R Function(Ok<T>) onOk) {
    return onError(this);
  }
}
