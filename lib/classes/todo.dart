import 'package:zenesus/constants.dart';

class TodoTileInfo {
  TodoTileInfo(
      {required this.title, required this.index, required this.isDone});
  String title;
  int index;
  bool isDone;
}

List<String> todoTilesToStringList(List<TodoTileInfo> infos) {
  List<String> names = [];
  for (TodoTileInfo info in infos) {
    if (info.isDone) {
      names.add("${info.title}${splitConstant}done");
    } else {
      names.add("${info.title}$splitConstant");
    }
  }
  return names;
}

List<TodoTileInfo> stringListToTodoTiles(List<String> infos) {
  List<TodoTileInfo> tileInfos = [];
  //print(infos);
  for (int i = 0; i < infos.length; i++) {
    tileInfos.add(TodoTileInfo(
        // ignore: unrelated_type_equality_checks
        title: infos[i].split(splitConstant)[0],
        index: i,
        isDone: infos[i].split(splitConstant)[1] == "done"));
  }
  return tileInfos;
}

String genAStringOfTodos(List<String> todos) {
  String todoString = "Todos:\n";
  for (String todo in todos) {
    todoString += "- ${todo.split(splitConstant)[0]} \n";
  }
  return todoString;
}
