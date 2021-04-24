import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:person_crud/shared/api/person_api.dart';
import 'package:person_crud/shared/models/person.dart';

class PersonController extends GetxController {
  var personList = [].obs;
  bool noData = false;

  PersonAPI personAPI = new PersonAPI();

  Future<bool> findAll() async {
    List<Person> list = await personAPI.findAll();

    personList.clear();
    personList.addAll(list);
    noData = list.isEmpty;
    return noData;
  }

  delete(int id) => personAPI.delete(id).then((value) {
        personList.removeWhere((element) => element.id == id);
        this.noData = personList.isEmpty;
      });

  save(Person person) =>
      personAPI.save(person).then((value) => personList.add(person));

  updatePerson(Person person) {
    personAPI.update(person).then((value) {
      Person oldPerson =
          personList.firstWhere((element) => person.id == element.id);
      int index = personList.indexOf(oldPerson);
      personList[index] = person;
    });
  }

  getImageBytes(String imageBase64) {
    if (imageBase64 == null) return null;
    List<String> imageSplitted = imageBase64.split(",");
    return base64.decode(
      imageSplitted.length > 1 ? imageSplitted[1] : imageSplitted[0],
    );
  }

  Future<Uint8List> fileToBytes(File file) async => await file.readAsBytes();

  imageByteToBase64(List<int> imageBytes) => base64Encode(imageBytes);
}
