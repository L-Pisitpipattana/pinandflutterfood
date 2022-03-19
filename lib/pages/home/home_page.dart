import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _foodData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLUTTER FOOD'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _handleClickButton,
              child: const Text('LOAD FOODS DATA'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _foodData.length,
              itemBuilder: (context, index) => _buildListItem(context, index),
            ),
          ),
        ],
      ),
    );
  }

  _handleClickButton() async {
    final url = Uri.parse('https://cpsu-test-api.herokuapp.com/foods');
    var result = await http.get(url);
    //print(result.body);

    var json = jsonDecode(result.body);
    String status = json['status'];
    String? message = json['message'];
    List<dynamic> data = json['data'];

    //print('Status: $status, Message: $message, Number of food: ${data.length}');

    setState(() {
      for (var element in data) {
        _foodData.add(element);
      }
    });
  }

  Widget _buildListItem(BuildContext context, int index) {
    var foodItem = _foodData[index];

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(8.0),
      elevation: 5.0,
      shadowColor: Colors.black.withOpacity(0.2),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: <Widget>[
            Image.network(
              foodItem['image'],
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          foodItem['name'],
                          style: TextStyle(
                              fontSize: 20.0
                          ),
                        ),
                        Text(
                          '${foodItem['price'].toString()} บาท',
                          style: TextStyle(
                              fontSize: 15.0
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}