import 'package:flutter/material.dart';
import 'package:selection_wave_slider/selection_wave_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            WaveSliderWithDragPoint(
              /*  dragButton: Container(
                color: Colors.blue,
              ),
              sliderHeight: 80,
              sliderPointColor: Colors.blue,
              sliderPointBorderColor: Colors.orange,
              sliderColor: Colors.red,
              toolTipBackgroundColor: Colors.yellow,
              toolTipBorderColor: Colors.green,
              toolTipTextStyle: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),*/
              onSelected: (value) {
                print(value);
              },
              optionToChoose: [
                "Yes",
                "May Be",
                "No",
              ],
            )
          ],
        ),
      ),
    );
  }
}
