class Task {
  String _name;
  bool _checked = false;

  Task(this._name);

  String get name => _name;
  bool get checked => _checked;

  set checked(v) => _checked = v;
}