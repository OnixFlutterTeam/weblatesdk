abstract class Mapper<T, E> {
  E map(T from);
}

abstract class MapperList<T, E> extends Mapper<T, E> {
  List<E> mapList(List<T> from) {
    return from.map(map).toList();
  }
}
