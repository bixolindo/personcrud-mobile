import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:person_crud/shared/controllers/person_controller.dart';
import 'package:person_crud/shared/models/person.dart';

enum SexEnum {
  MAN,
  WOMAN,
}

class PersonForm extends StatefulWidget {
  Person person;

  PersonForm({
    this.person,
  });
  @override
  _PersonFormState createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  String _title = "";

  final picker = ImagePicker();
  Uint8List _profileImage;
  Uint8List _newProfileImage;
  bool _loadingImage = false;

  final _formKey = GlobalKey<FormState>();
  SexEnum _sex = SexEnum.MAN;
  final _nameController = new TextEditingController(text: "");
  final _ageController = new TextEditingController(text: "");
  final _addressController = new TextEditingController(text: "");

  PersonController personController;

  @override
  void initState() {
    super.initState();

    _title = widget.person == null ? "New Person" : "Edit Person";
    personController = Get.put(PersonController());

    if (widget.person != null) {
      _nameController.text = widget.person.name;
      _addressController.text = widget.person.address;
      _ageController.text = widget.person.age.toString();
      _sex = SexEnum.values[widget.person.sex];
      _profileImage = widget.person.base64 != null
          ? personController.getImageBytes(widget.person.base64)
          : null;
    }
  }

  Future getImage() async {
    setState(() {
      _loadingImage = true;
    });
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _newProfileImage =
          await personController.fileToBytes(new File(pickedFile.path));
    } else {
      print('No image selected.');
    }

    setState(() {
      _loadingImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(_title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => getImage(),
                  child: CircleAvatar(
                    child:
                        _profileImage == null ? buildImageCenterIcon() : null,
                    foregroundImage: buildImage(),
                    radius: 70,
                    backgroundColor: Color(0xfff2f2f2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            hintText: 'Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            hintText: 'Age',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            hintText: 'Addess',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<SexEnum>(
                    value: SexEnum.MAN,
                    groupValue: _sex,
                    onChanged: (value) {
                      setState(() {
                        _sex = value;
                      });
                    },
                  ),
                  Text("Man"),
                  Radio<SexEnum>(
                    value: SexEnum.WOMAN,
                    groupValue: _sex,
                    onChanged: (value) {
                      setState(() {
                        _sex = value;
                      });
                    },
                  ),
                  Text("Woman")
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () => handleSubmit(),
      ),
    );
  }

  ImageProvider<Object> buildImage() {
    if (_newProfileImage != null) return MemoryImage(_newProfileImage);

    if (_profileImage != null) return MemoryImage(_profileImage);

    return null;
  }

  buildImageCenterIcon() {
    if (_loadingImage) {
      return CircularProgressIndicator(
        strokeWidth: 1.5,
      );
    }
    return Icon(Icons.add_a_photo);
  }

  handleSubmit() {
    if (!_formKey.currentState.validate()) return;

    if (widget.person != null)
      update();
    else
      save();

    Navigator.of(context).pop();
  }

  save() {
    personController.save(mountPerson());
  }

  update() {
    personController.updatePerson(mountPerson());
  }

  Person mountPerson() {
    return new Person(
        id: widget.person?.id,
        address: _addressController.text,
        name: _nameController.text,
        age: int.parse(_ageController.text),
        sex: _sex.index,
        base64: mountImageToSend());
  }

  String mountImageToSend() {
    if (_newProfileImage != null)
      return personController.imageByteToBase64(_newProfileImage);

    if (widget.person != null) return widget.person.base64;

    return null;
  }
}
