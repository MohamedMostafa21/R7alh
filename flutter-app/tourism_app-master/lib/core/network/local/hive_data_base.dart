import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<Box> openHiveBox(String nameBox) async {
  if (!Hive.isBoxOpen(nameBox)) {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }
  return Hive.openBox(nameBox);
}
