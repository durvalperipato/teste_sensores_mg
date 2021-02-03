class ProductsModel {
  String name;

  ProductsModel({this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  ProductsModel.fromMap(Map<String, dynamic> map) {
    this.name = map['name'];
  }

  @override
  String toString() {
    return (name);
  }
}
