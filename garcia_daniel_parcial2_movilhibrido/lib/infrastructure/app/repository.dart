abstract class Repository<T, D> {
  Future<T> execute(D params);
}
