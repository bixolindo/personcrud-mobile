class Person {
  String address;
  int age;
  String base64;
  int id;
  String name;
  int sex;

  Person({this.address, this.age, this.base64, this.id, this.name, this.sex});

  Person.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    age = json['age'];
    base64 = json['base64'];
    id = json['id'];
    name = json['name'];
    sex = json['sex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['age'] = this.age;
    data['base64'] = this.base64;
    data['id'] = this.id;
    data['name'] = this.name;
    data['sex'] = this.sex;
    return data;
  }
}
