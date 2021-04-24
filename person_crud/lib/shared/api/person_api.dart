import 'package:person_crud/config/base_api.dart';
import 'package:person_crud/shared/models/person.dart';

class PersonAPI {
  String _endpoint = "/person";

  Future<List<Person>> findAll() async {
    try {
      final response = await BaseAPI().get(_endpoint);

      List<dynamic> rawList = response.data;

      List<Person> personList = rawList
          .map(
            (person) => Person.fromJson(person),
          )
          .toList();

      return personList;
    } catch (e) {
      return [];
    }
  }

  Future<Person> findById(int id) async {
    final response = await BaseAPI().get(_endpoint + "/$id");

    return Person.fromJson(response.data);
  }

  Future<Person> save(Person person) async {
    final response = await BaseAPI().post(_endpoint, person.toJson());

    return Person.fromJson(response.data);
  }

  Future<Person> update(Person person) async {
    final response =
        await BaseAPI().put(_endpoint + "/${person.id}", person.toJson());

    return Person.fromJson(response.data);
  }

  Future<bool> delete(int id) async {
    final response = await BaseAPI().delete(_endpoint, id);

    return response.statusCode == 200;
  }
}
