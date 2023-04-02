import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/layers/layer_create_page.dart';
import 'package:flutter_application_1/views/wells/well_create_page.dart';


class IntervalIndexPage extends StatefulWidget {
  @override
  IntervalIndexPageState createState() => IntervalIndexPageState();
}

var dropdownValues = ['Галька', 'Песок', 'Чернозем', 'Глина'];

class IntervalIndexPageState extends State<IntervalIndexPage> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Бурение"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () { 
            Navigator.of(context).pop();
          }, ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Глубина',
                hintText: 'Введите глубину интервала'
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: DropdownButton<String>(
              value: dropdownValue,
              isExpanded: true,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              icon: Icon(Icons.arrow_drop_down),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              iconSize: 24,
              hint: Container(
                child: Text("Выберите материал"),
              ),
              items: <String>['Галька', 'Песок', 'Чернозем', 'Глина']
                .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }).toList(),
              // Step 5.
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue ?? "";
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Описание',
                hintText: 'Введите описание интервала'
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Комментарий',
                hintText: 'Комментарий'
              ),
            ),
          ),
          ElevatedButton(
            child: Text('Сохранить'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              // Navigator.push(
              //   context, MaterialPageRoute(builder: (_) => LayerCreatePage()));
            },
          ),
        ],
      ),
    );
  }
}
