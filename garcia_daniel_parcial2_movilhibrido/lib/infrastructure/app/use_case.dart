abstract class UseCase<T, D> {
  Future<T> execute(D params);
}
