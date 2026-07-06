class IdGenerator {
  IdGenerator({int seed = 1}) : _nextId = seed;

  int _nextId;

  int next() => _nextId++;

  void syncFrom(Iterable<int> existingIds) {
    var maxId = 0;
    for (final id in existingIds) {
      if (id > maxId) maxId = id;
    }
    _nextId = maxId + 1;
  }
}
