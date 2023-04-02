import 'package:flutter/material.dart';




class WellCreatePage extends StatefulWidget {
  @override
  WellCreatePageState createState() => WellCreatePageState();
}

class WellCreatePageState extends State<WellCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Новая скважина"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () { 
            Navigator.of(context).pop();
          }, ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: 
            TextField(
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.blue),
              hintText: "Наименование скважины"
            ),
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          ),
          
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Text('Сохранить'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
