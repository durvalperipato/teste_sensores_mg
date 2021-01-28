class Products {
  int id;
  String name;

  Products({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Products.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }

  @override
  String toString() {
    return ('ID: ' + id.toString() + ', Nome: ' + name);
  }
}
