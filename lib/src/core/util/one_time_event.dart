class OneTimeEvent<T> {
  final T _value;
  bool _consumed = false;

  OneTimeEvent(this._value);

  T? consume() {
    if (_consumed) return null;
    _consumed = true;
    return _value;
  }
}
