abstract class Repository<T> {
  /* Fetch all */
  Future<List<T>> getAll();

  /* Add item */
  Future<void> add(T item);

  /* Add item */
  Future<void> update(T item);

  /* Add item */
  Future<void> delete(String uID);
}
