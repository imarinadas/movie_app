import 'package:hive/hive.dart';
part 'towatch_list_model.g.dart';

@HiveType(typeId: 1)
class TowatchListModel{

  TowatchListModel({required this.name});

  @HiveField(0)
  String name;

  @override
  String toString() {
    return 'TowatchListModel{name: $name}';
  }
}