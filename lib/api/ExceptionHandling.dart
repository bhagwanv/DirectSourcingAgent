sealed class Result<S, E extends Exception> {
  const Result();
  R when<R>({
    required R Function(S value) success,
    required R Function(E exception) failure,
  });
}

class Success<S, E extends Exception> extends Result<S, E> {
  final S value;

  Success(this.value);

  @override
  R when<R>({
    required R Function(S value) success,
    required R Function(E exception) failure,
  }) {
    return success(value);
  }
}

// Failure subclass representing a failed result with an exception
class Failure<S, E extends Exception> extends Result<S, E> {
  final E exception;

  Failure(this.exception);

  @override
  R when<R>({
    required R Function(S value) success,
    required R Function(E exception) failure,
  }) {
    return failure(exception);
  }
}