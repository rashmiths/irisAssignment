import 'package:flutter/material.dart';
import './Dummy_Data.dart';

class ListOfTasks extends StatelessWidget {
  var data=dummyCategories;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 30),
          padding: EdgeInsets.only(bottom:10),
          child: Text(
            'Tasks',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Container(
          height: 400,
          child: ListView.builder(
              itemBuilder: (ctxt, index) {
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 8,
                  ),
                  child: ListTile(
                      leading: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: FittedBox(
                              child: Text(
                                '# ${index + 1}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                      title: FittedBox(
                        child: Text(
                          data[index].title,
                          style: TextStyle(fontFamily: 'Quicksand',fontSize: 6,fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(data[index].time),
                      trailing: IconButton(
                          icon: Icon(Icons.delete), onPressed: () {})),
                );
              },
              itemCount: data.length),
        ),
      ],
    );
  }
}
