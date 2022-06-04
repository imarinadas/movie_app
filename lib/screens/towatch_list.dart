import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app_flutter/model/towatch_list_model.dart';
import 'package:movies_app_flutter/widgets/common_submit_bottom.dart';

class TowatchList extends StatefulWidget {
  const TowatchList({Key? key}) : super(key: key);

  @override
  State<TowatchList> createState() => _TowatchListState();
}

class _TowatchListState extends State<TowatchList> {
  TextEditingController _nameController = TextEditingController();

  Box<TowatchListModel> localDB = Hive.box<TowatchListModel>("towatch_list");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("To Watch List"),
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              _buildInputField(),
              _buildSubmitButton(),
              _buildDBList()
            ],
          ),
        ));
  }

  Widget _buildInputField() {
    return Container(
      child: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(hintText: "Movie Title"),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      child: CommonSubmitButton(
        labelButton: 'Add Movie',
        submitCallback: (String) {
          if (_nameController.text.isNotEmpty) {
            localDB.add(TowatchListModel(name: _nameController.text));
            _nameController.clear();
            setState(() {});
          }
        },
      ),
    );
  }

  Widget _buildDBList() {
    return Expanded(
      child: ValueListenableBuilder(
          valueListenable: localDB.listenable(),
          builder: (BuildContext context, Box<dynamic> value, Widget? child) {
            if (value.isEmpty) {
              return Center(
                child: Text("No Data Available"),
              );
            }

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Center(
                    child: Text("${localDB.get(index)!.name}")
                );
              },
              itemCount: localDB.length,
            );
          }),
    );
  }
}
