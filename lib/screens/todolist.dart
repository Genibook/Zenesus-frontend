import 'package:zenesus/widgets/shakey.dart';
import 'package:flutter/material.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/constants.dart';
import 'package:zenesus/classes/todo.dart';
import 'package:zenesus/widgets/navbar.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  // ignore: library_private_types_in_public_api

  TodoState createState() => TodoState();
}

class TodoState extends State<TodoList> {
  final _buttonshakeKey = GlobalKey<ShakeWidgetState>();
  final _textshakeKey = GlobalKey<ShakeWidgetState>();
  List<String> todoList = [];
  Future<List<String>>? _futureTodos;
  final TextEditingController _todoController = TextEditingController();
  late List<Widget> todos;

  @override
  void initState() {
    super.initState();
  }

  FutureBuilder<List<String>> buildFutureBuilder() {
    return FutureBuilder(
        future: _futureTodos,
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            todoList = snapshot.data!;
            List<Widget> todos = _getItems();
            child = Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Todos",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 50),
                        ),
                        ReorderableListView(
                          buildDefaultDragHandles: false,
                          header: ShakeWidget(
                              key: _textshakeKey,
                              // 5. configure the animation parameters
                              shakeCount: 3,
                              shakeOffset: 10,
                              shakeDuration: const Duration(milliseconds: 400),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: _todoController,
                                onFieldSubmitted: (value) =>
                                    todoListSubmit("text"),
                                decoration: const InputDecoration(
                                    hintText: 'Add a new todo item',
                                    border: InputBorder.none),
                              )),
                          onReorder: (int oldIndex, int newIndex) async {
                            setState(() {
                              if (newIndex > oldIndex) newIndex--;
                              final item = todoList.removeAt(oldIndex);
                              todoList.insert(newIndex, item);
                              setTodo(todoList);
                              // final itemm = todos.removeAt(oldIndex);
                              // todos.insert(newIndex, itemm);
                            });

                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const TodoList(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: todos,
                        ),
                      ])),
            );
          } else if (snapshot.hasError) {
            child = Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                        'Error: ${snapshot.error} \n Please report this to zenesus.gradebook@gmail.com'),
                  )
                ]));
          } else {
            child = Column();
            //child = const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: child,
            // floatingActionButton: ShakeWidget(
            //     // 4. pass the GlobalKey as an argument
            //     key: _buttonshakeKey,
            //     // 5. configure the animation parameters
            //     shakeCount: 3,
            //     shakeOffset: 10,
            //     shakeDuration: const Duration(milliseconds: 400),
            //     // 6. Add the child widget that will be animated
            //     child: FloatingActionButton(
            //       onPressed: () => todoListSubmit("button"),
            //       tooltip: 'Add item',
            //       child: const Icon(Icons.add),
            //     )),
            bottomNavigationBar: Navbar(
              selectedIndex: todoNavNum,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _futureTodos = readTodos();
    });
    return buildFutureBuilder();
  }

  void _addTodoItem(String title) {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    setState(() {
      todoList.add("$title$splitConstant");
    });
    writeTodo("$title$splitConstant");
    _todoController.clear();
  }

  void todoListSubmit(String mode) {
    String text = _todoController.text;
    if (text != "") {
      _addTodoItem(text);
    } else {
      if (mode == "text") {
        _textshakeKey.currentState?.shake();
      } else if (mode == "button") {
        _buttonshakeKey.currentState?.shake();
      }
    }
  }

  Widget _buildTodoItem(TodoTileInfo info) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Column(key: ValueKey("${info.index}_todoKey"), children: [
      const SizedBox(
        height: 10,
      ),
      ReorderableDragStartListener(
          index: info.index,
          child: ListTile(
            // ignore: avoid_unnecessary_containers
            title: Container(
                child: TextFormField(
              maxLines: null,
              enabled: !info.isDone,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              initialValue: Text(
                info.title,
                style: TextStyle(
                    fontSize: 16,
                    decoration:
                        info.isDone ? TextDecoration.lineThrough : null),
              ).data,
              onFieldSubmitted: ((value) {
                if (info.isDone) {
                  setState(() {
                    todoList[info.index] = "$value${splitConstant}done";
                    setTodo(todoList);
                  });
                } else {
                  setState(() {
                    todoList[info.index] = "$value$splitConstant";
                    setTodo(todoList);
                  });
                }
              }),
            )),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tileColor: isDarkMode
                ? info.isDone
                    ? Colors.grey[800]
                    : Colors.grey[700]
                : info.isDone
                    ? Colors.grey[300]
                    : Colors.grey[200],
            leading: IconButton(
              padding: const EdgeInsets.all(0),
              icon: Icon(
                info.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                color: primaryColor,
              ),
              onPressed: () {
                if (info.isDone) {
                  setState(() {
                    todoList[info.index] = "${info.title}$splitConstant";
                    info.isDone = false;
                  });
                } else {
                  setState(() {
                    todoList[info.index] = "${info.title}${splitConstant}done";
                    info.isDone = true;
                  });
                }

                setTodo(todoList);
              },
            ),
            trailing: Container(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    color: todoDeleteRed,
                    borderRadius: BorderRadius.circular(5)),
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  iconSize: 18,
                  onPressed: (() {
                    setState(() {
                      todoList.removeAt(info.index);
                    });

                    deleteTodo(info.index);
                  }),
                )),
          ))
    ]);
  }

  List<Widget> _getItems() {
    final List<Widget> todoWidgets = <Widget>[];
    List<TodoTileInfo> tileInfos = stringListToTodoTiles(todoList);
    for (int i = 0; i < tileInfos.length; i++) {
      todoWidgets.add(_buildTodoItem(tileInfos[i]));
    }
    return todoWidgets;
  }
}
