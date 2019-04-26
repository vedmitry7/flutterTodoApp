import 'package:flutter/material.dart';
import 'package:to_do_app/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _addInputController = TextEditingController();
  final _searchInputController = TextEditingController();

  List<Task> _currentShownTask = [];
  List<Task> _storage = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Todo app"),
      ),
      body: Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: _searchInputController,
                    decoration: new InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none),
                    onChanged: (t) {
                      filter(t);
                    },
                  ),
                  trailing: new IconButton(icon: new Icon(Icons.cancel, color: Colors.black38), onPressed: () {
                    _searchInputController.clear();
                    filter('');
                  },),
                ),
              ),
            ),
          ),
          Container(
              height: 48,
              decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.black12, width: 1
                    ),
                  )
              ),
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: TextField(
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                        border: InputBorder.none,
                        hintText: 'Add a task',
                      ),
                      controller: _addInputController,
                      onChanged: (text) {
                        setState(() {
                        });
                      },
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      add();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                color: Colors.black12, width: 1
                            ),
                          )
                      ),
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add_circle, color: _addInputController.text.isEmpty ? Colors.black38 : Colors.blueAccent),
                          SizedBox(
                            width: 10,
                          ),
                          Text("ADD", style: TextStyle(color: Colors.black54))
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),

          Expanded(
              child: ListView.builder(
                itemCount: _currentShownTask.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                    onTap: () {
                      changeTaskState(index, !_currentShownTask[index].checked);
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.black12,
                                width: 1
                            ),
                          )
                      ),
                      height: 48,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            child:
                            Text(_currentShownTask[index].name,
                                style: TextStyle(
                                    color: _currentShownTask[index].checked ? Colors.black38 : Colors.black87,
                                    decoration: _currentShownTask[index].checked ? TextDecoration.lineThrough : TextDecoration.none)),
                          ),
                          _currentShownTask[index].checked ?
                          Icon(Icons.check_circle, color: Colors.black38)
                              :
                          Container(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: new Border.all(
                                  color: Colors.blueAccent,
                                  width: 1,
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
          )
        ],
      ),
    );
  }

  void add() {
    if(_addInputController.text.isEmpty){
      return;
    }
    _storage.add(Task(_addInputController.text));
    _addInputController.clear();
    filter(_searchInputController.text);
  }

  filter(text) {
    setState(() {
      _currentShownTask.clear();
      for(Task t in _storage){
        if(t.name.startsWith(text)){
          _currentShownTask.add(t);
        }
        sortTasks(_currentShownTask);
      }
    });
  }

  void changeTaskState(int index, bool value) {
    setState(() {
      _currentShownTask[index].checked = value;
      sortTasks(_currentShownTask);
    });
  }

  void sortTasks(List<Task> list) {
    list.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    list.sort((a, b) {
      return a.checked == true && b.checked == false ? 1 : -1;
    });
  }
}
