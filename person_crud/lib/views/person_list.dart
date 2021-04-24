import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:person_crud/shared/controllers/person_controller.dart';
import 'package:person_crud/shared/models/person.dart';
import 'package:person_crud/views/person_form.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PersonList extends StatefulWidget {
  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final personController = Get.put(PersonController());

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _onRefresh() async {
    bool noData = await personController.findAll();
    _refreshController.refreshCompleted();

    if (noData) {
      _refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Person Crud"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => navigateToPersonForm(),
      ),
      body: GetX(
        init: PersonController(),
        builder: (controller) {
          return SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                body = Text(controller.noData ? "No more data" : "");
                return Container(
                  height: 55,
                  child: Center(child: body),
                );
              },
            ),
            child: ListView.builder(
              itemCount: controller.personList.length,
              itemBuilder: (BuildContext context, int index) {
                Person person = controller.personList[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () => navigateToPersonForm(
                        person: person,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: person.base64 == null
                            ? null
                            : MemoryImage(
                                controller.getImageBytes(person.base64),
                              ),
                        backgroundColor: Colors.indigoAccent,
                        child: person.base64 == null
                            ? Text(
                                getFirstLetterOfName(person.name),
                              )
                            : null,
                        foregroundColor: Colors.white,
                      ),
                      title: Text(person.name),
                      subtitle: Text(person.address),
                    ),
                  ),
                  actions: <Widget>[],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        controller.delete(person.id);
                        _refreshController.requestRefresh();
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  navigateToPersonForm({Person person}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonForm(
          person: person,
        ),
      ),
    ).whenComplete(() => _refreshController.requestRefresh());
  }

  getFirstLetterOfName(String name) {
    return name.substring(0, 1).toUpperCase();
  }
}
