import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pinandflutterfood/models/api_result.dart';
import 'package:http/http.dart' as http;
import 'package:pinandflutterfood/pages/home/home_page.dart';

class PinPage extends StatefulWidget {
  static const buttonSize = 60.0;

  const PinPage({Key? key}) : super(key: key);

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  String _input = '';
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.pink.shade50,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.green.shade100,
                ],
              )
          ),
          /*body*/child: Padding(
          padding: const EdgeInsets.only(top: 8.0,bottom: 0.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outlined,
                      size: 70.0,
                      color: Colors.black54,
                    ),
                    Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 25.0 , color: Colors.black54,fontWeight: FontWeight.bold),
                    ),Text(
                      'Enter PIN to login',
                      style: TextStyle(fontSize: 18.0, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_input, style: TextStyle(fontSize: 20.0)),
            ),*/Padding(
                padding: const EdgeInsets.only(top: 0.0,bottom: 60.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Collection for
                    for (var i = 0; i < _input.length; i++)
                      Container(
                        width: 25.0,
                        height: 25.0,
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    for(var i = 0; i<6-_input.length;i++)
                      Container(
                        width: 25.0,
                        height: 25.0,
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade200,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(1),
                        _buildButton(2),
                        _buildButton(3),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(4),
                        _buildButton(5),
                        _buildButton(6),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(7),
                        _buildButton(8),
                        _buildButton(9),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: PinPage.buttonSize,
                            height: PinPage.buttonSize,
                          ),
                        ),
                        _buildButton(0),
                        _buildButton(-1),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
        ),),
    );
  }
  Future<bool> _login() async {
    setState(() {
     _isLoading = true;
    });
    final url = Uri.parse('https://cpsu-test-api.herokuapp.com/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pin': _input}),
    );
    setState(() {
      _isLoading = false;
    });
    var json = jsonDecode(response.body);
    var apiResult = ApiResult.fromJson(json);
    return apiResult.data;
  }

  Widget _buildButton(int num) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          if (num == -1) {
            print('Backspace');

            setState(() {
              // '12345'
              var length = _input.length;
              _input = _input.substring(0, length - 1);
            });
          } else {
            if(_input.length<6)
              setState(() {
                _input = '$_input$num';

              });
            if(_input.length==6){
              var loginSuccess = await _login();
              if (loginSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }else{
                showMaterialDialog(context, 'Incorrect PIN', 'Please try again');
                setState(() {
                  _input = '';
                });
              }

            }
            print('You pressed $num');
          }
        },
        borderRadius: BorderRadius.circular(PinPage.buttonSize / 2),
        child: Container(
          decoration: (num == -1)
              ? null
              : BoxDecoration(
            border: Border.all(width: 2.0),
            shape: BoxShape.circle,
            color: Colors.white30,
          ),
          alignment: Alignment.center,
          width: PinPage.buttonSize,
          height: PinPage.buttonSize,
          // conditional operator (?:)
          child: (num == -1) ? Icon(Icons.backspace_outlined) : Text('$num',style: TextStyle(
              fontSize: 20.0),),
        ),
      ),
    );
  }

  void showMaterialDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

/*class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _pinLength = 6;
  var _input = ''; // state variable
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                /*stops: [
                  0.0,
                  0.95,
                  1.0,
                ],*/
                colors: [
                  Colors.white,
                  //Color(0xFFD8D8D8),
                  //Color(0xFFAAAAAA),
                  Theme.of(context).colorScheme.background.withOpacity(0.5),
                  //Theme.of(context).colorScheme.background.withOpacity(0.6),
                  //Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 90.0,
                              color:
                                  Theme.of(context).textTheme.headline1?.color,
                            ),
                            Text(
                              'LOGIN',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              'Enter PIN to login',
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < _input.length; i++)
                              Container(
                                margin: const EdgeInsets.all(4.0),
                                width: 24.0,
                                height: 24.0,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle),
                              ),
                            for (var i = _input.length; i < 6; i++)
                              Container(
                                margin: const EdgeInsets.all(4.0),
                                width: 24.0,
                                height: 24.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                  _buildNumPad(context),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNumPad(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
          [-2, 0, -1],
        ].map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((item) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoginButton(
                  number: item,
                  onClick: () {
                    _handleClickButton(context, item);
                  },
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  _handleClickButton(BuildContext context, int num) async {
    if (num == -1) {
      if (_input.isNotEmpty) {
        setState(() {
          _input = _input.substring(0, _input.length - 1);
        });
      }
    } else if (_input.length < _pinLength) {
      setState(() {
        _input = '$_input$num';
      });
    }

    if (_input.length == _pinLength) {
      var loginSuccess = await _login();
      if (loginSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        _showOkDialog(context, 'Incorrect PIN', 'Please try again');
        setState(() {
          _input = '';
        });
      }
    }
  }

  Future<bool> _login() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse('https://cpsu-test-api.herokuapp.com/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pin': _input}),
    );
    setState(() {
      _isLoading = false;
    });
    var json = jsonDecode(response.body);
    var apiResult = ApiResult.fromJson(json);
    return apiResult.data;
  }

  void _showOkDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  final int number;
  final Function() onClick;

  const LoginButton({
    required this.number,
    required this.onClick,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: number == -2 ? null : onClick,
      child: Container(
        width: 75.0,
        height: 75.0,
        decoration: number < 0
            ? null
            : BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
                border: Border.all(
                  width: 3.0,
                  color: Theme.of(context).textTheme.headline1!.color!,
                ),
              ),
        child: Center(
          child: number >= 0
              ? Text(
                  '$number', // number.toString()
                  style: Theme.of(context).textTheme.headline6,
                )
              : (number == -1
                  ? const Icon(
                      Icons.backspace_outlined,
                      size: 28.0,
                    )
                  : const SizedBox.shrink()),
        ),
      ),
    );
  }
}*/