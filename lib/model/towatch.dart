import 'package:hive/hive.dart';
import 'package:movies_app_flutter/screens/towatch_list_screen.dart';
part 'towatch.g.dart';

@HiveType(typeId: 0)
class Towatch extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String release;

  Towatch({
    required this.title,
    required this.release,
  });
}