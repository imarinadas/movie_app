import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app_flutter/model/boxes.dart';
import 'package:movies_app_flutter/model/towatch.dart';
import 'add_towatch_screen.dart';

class TowatchListScreen extends StatefulWidget {
  final String title;
  const TowatchListScreen({Key? key, required this.title}) :
        super(key: key);

  @override
  _TowatchListScreenState createState() => _TowatchListScreenState();
}

class _TowatchListScreenState extends State<TowatchListScreen> {
  get title => null;
  get release => null;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('To Watch'),
          centerTitle: true,
    ),
        body: ValueListenableBuilder(
          valueListenable:
            Hive.box<Towatch>(HiveBoxex.towatch).listenable(),
          builder: (context, Box<Towatch> box, _){
            if(box.values.isEmpty){
              return Center(
                child: Text('Data Unavailable'),
              );
            }
            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index){
                Towatch? res = box.getAt(index);
                return Dismissible(
                  background: Container(
                  color: Colors.red,
          ),
          key: UniqueKey(),
          onDismissed: (direction){
                    res!.delete();
          },
          child: ListTile(
              title: Text(res!.title),
              subtitle: Text(res!.release),
          ),
      );
      },);}
      ),
     floatingActionButton: FloatingActionButton(
         tooltip: 'Add To Watch',
         child: Icon(Icons.add),
         onPressed: ()=>{
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context)=> AddTowatchScreen(),
         ))
     },)
  );
  }
  void dispose(){
    Hive.close();
    super.dispose();
  }
}