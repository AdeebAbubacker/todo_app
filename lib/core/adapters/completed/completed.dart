import 'package:hive/hive.dart';
part 'completed.g.dart';

@HiveType(typeId: 1)
class Completed {
  @HiveField(0)
  String name;

  Completed({required this.name});
}
