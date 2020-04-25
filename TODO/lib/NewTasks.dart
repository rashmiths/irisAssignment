import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class NewTasks extends StatefulWidget {
  @override
  _NewTasksState createState() => _NewTasksState();
}

class _NewTasksState extends State<NewTasks> {
  DateTime selectedDate;
  TextEditingController titlecontroller;
  TextEditingController timecontroller;

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }
  void SubmitData() {
    
    

   
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
          child: Card(
            elevation: 5.0,
            child: Container(
              padding: EdgeInsets.only(
                  top: 10.0,
                  left: 10.0,
                  right: 10.0,
                   bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Title',

                        labelStyle: TextStyle(color: Colors.black)),
                     controller: titlecontroller,
                     onSubmitted: (_) => SubmitData(),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Time',
                        labelStyle: TextStyle(color: Colors.black)),
                    keyboardType: TextInputType.number,
                     controller: timecontroller,
                     onSubmitted: (_) => SubmitData(),
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: selectedDate == null
                              ? Text('No Date Chosen !')
                              : Text(
                                  'ChosenDate:${DateFormat.yMd().format(selectedDate)}'),
                        ),
                        FlatButton(
                            child: Text('Choose Date',
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.bold)),
                            onPressed: presentDatePicker),
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: Text('Add Task'),
                    color: Colors.blue,
                    textColor: Colors.white,
                     onPressed: SubmitData,
                    
                  )
                ]
              )
            ),
            
            ),
    );
    
            

      
  
  }
}