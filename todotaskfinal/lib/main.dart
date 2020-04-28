import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivetodoteach/todo_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

const String todoBoxName = "todo";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>(todoBoxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.grey,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum TodoFilter { ALL, COMPLETED, INCOMPLETED }

class _MyHomePageState extends State<MyHomePage> {
  Box<TodoModel> todoBox;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController labeltitle = TextEditingController();
  final TextEditingController labeldetail = TextEditingController();

  TodoFilter filter = TodoFilter.ALL;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoBox = Hive.box<TodoModel>(todoBoxName);
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODO',
          style: TextStyle(
              fontFamily: 'Quicksand',
              color: Colors.black,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Theme(
              data: Theme.of(context).copyWith(
                cardColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  ///Todo : Take action accordingly
                  ///
                  if (value.compareTo("All") == 0) {
                    setState(() {
                      filter = TodoFilter.ALL;
                    });
                  } else if (value.compareTo("Compeleted") == 0) {
                    setState(() {
                      filter = TodoFilter.COMPLETED;
                    });
                  } else {
                    setState(() {
                      filter = TodoFilter.INCOMPLETED;
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return ["All", "Compeleted", "Incompleted"].map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                },
              )),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15.0),
                width: double.infinity,
                height: 100,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      DateFormat.d().format(DateTime.now()),
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                  title: Text(DateFormat.yMMM().format(DateTime.now()),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 24)),
                  subtitle: Text(DateFormat.EEEE().format(DateTime.now()),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 18)),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.lightBlue.withOpacity(0.7),
                      Colors.lightBlue
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // borderRadius: BorderRadius.circular(15),
                ),
              ),
              Container(
                child: Text(
                  'Tasks',
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                padding: EdgeInsets.all(30),
              ),
              SizedBox(
                height: 30,
              ),
              todoBox.isEmpty
                  ? Column(
                      children: <Widget>[
                        Text(
                          'No TASKS Added!',
                          style:
                              TextStyle(fontFamily: 'Quicksand', fontSize: 16),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 200,
                          child: Image.asset(
                            'assets/images/waiting.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    )
                  : ValueListenableBuilder(
                      valueListenable: todoBox.listenable(),
                      builder: (context, Box<TodoModel> todos, _) {
                        List<int> keys;

                        if (filter == TodoFilter.ALL) {
                          keys = todos.keys.cast<int>().toList();
                        } else if (filter == TodoFilter.COMPLETED) {
                          keys = todos.keys
                              .cast<int>()
                              .where((key) => todos.get(key).isCompleted)
                              .toList();
                        } else {
                          keys = todos.keys
                              .cast<int>()
                              .where((key) => !todos.get(key).isCompleted)
                              .toList();
                        }

                        return Container(
                          height: 400.0,
                          child: ListView.separated(
                            itemBuilder: (_, index) {
                              final int key = keys[index];
                              final TodoModel todo = todos.get(key);

                              return Card(
                                child: ListTile(
                                  title: Text(
                                    // data[index].title,
                                    todo.title,
                                    style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        // fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(todo.detail,
                                      style: TextStyle(
                                        // fontSize: 20
                                        )),
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.check,
                                        color: todo.isCompleted
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      CircleAvatar(
                                        radius: 50.0,
                                        backgroundColor: Colors.lightBlue,
                                        child: Icon(Icons.calendar_today,
                                            color: Colors.white),
                                        // Image.asset('assets/images/3.jpg',
                                        // fit:BoxFit.cover)

                                        // FittedBox(
                                        //   child: Text(
                                        //     '# ${index + 1}',
                                        //     style: TextStyle(color: Colors.white),
                                        //   ),
                                        // ),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              child: Dialog(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          width: 2.0,
                                                          color: Colors.black)),
                                                  margin: EdgeInsets.all(10),
                                                  padding: EdgeInsets.all(10),
                                                  height: 200,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      TextField(
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'Newtitle',
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Quicksand',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        controller: labeltitle,
                                                      ),
                                                      TextField(
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'NewDetail',
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Quicksand',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller: labeldetail,
                                                      ),
                                                      RaisedButton(
                                                          color: Colors.black,
                                                          child: Text(
                                                            'okay',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () {
                                                            final String
                                                                titlelabel =
                                                                labeltitle.text;
                                                            final String
                                                                detaillabel =
                                                                labeldetail
                                                                    .text;

                                                            TodoModel todo = TodoModel(
                                                                title:
                                                                    titlelabel,
                                                                detail:
                                                                    detaillabel,
                                                                isCompleted:
                                                                    false);

                                                            setState(() {
                                                              if (todo.title
                                                                  .isEmpty)
                                                                return;
                                                              if (todo.detail
                                                                  .isEmpty)
                                                                return;
                                                              todoBox.put(
                                                                  key, todo);
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            todoBox.delete(key);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        child: Dialog(
                                            child: Container(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  "Mark as completed",
                                                  style: TextStyle(
                                                      fontFamily: 'Quicksand',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () {
                                                  TodoModel mTodo = TodoModel(
                                                      title: todo.title,
                                                      detail: todo.detail,
                                                      isCompleted: true);

                                                  todoBox.put(key, mTodo);

                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ),
                                        )),);
                                  },
                                  
                                ),
                              );
                            },
                            separatorBuilder: (_, index) => Divider(),
                            itemCount: keys.length,
                            shrinkWrap: true,
                          ),
                        );
                      },
                    )
            ],
          ),
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {                        //BOTTOMSHEET
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return Container(
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 5.0,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10.0,
                            left: 10.0,
                            right: 10.0,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Title",
                                  labelStyle: TextStyle(color: Colors.black)),
                              controller: titleController,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Detail",
                                  labelStyle: TextStyle(color: Colors.black)),
                              controller: detailController,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text("Add TASK"),
                              onPressed: () {
                                ///Todo : Add Todo in hive
                                final String title = titleController.text;
                                final String detail = detailController.text;

                                TodoModel todo = TodoModel(
                                    title: title,
                                    detail: detail,
                                    isCompleted: false);
                                checkingdata(todo);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              );
        },
      ),
    );
  }

  void checkingdata(TodoModel todo) {
    if (todo.title.isEmpty) return;
    if (todo.detail.isEmpty) return;

    setState(() {
      todoBox.add(todo);
      Navigator.pop(context);
    });
  }
 
}
