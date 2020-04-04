import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';


List<int> fermaDecomposition(Map<String, int> map){
  int decompositionNumber = map["decompositionNumber"];
  int maxSteps = map["steps"];
  int currentStep = 0;
  int x = sqrt(decompositionNumber).toInt();

  double res;
  int resSqrt;
  do {
    if(currentStep == maxSteps) {
      return null;
    }
    x++;
    currentStep++;
    res = pow(x, 2) - decompositionNumber.toDouble();
    resSqrt = sqrt(res).toInt();
  }while(pow(resSqrt, 2) != res);

  int y = sqrt(pow(x, 2) - decompositionNumber).toInt();
  int p = x - y;
  int q = x + y;
  List<int> array = [p, q, currentStep];
  return array;
}


void main() => runApp(FermaApp());

class FermaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3.1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Ferma decomposition'),
    );
  }
}

class HomePage extends StatelessWidget{
  final String title;
  HomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Title(
                title: "Лабораторна робота 3.1.",
                description: "Реалізація задачі розкладання числа на прості множники.",
              ),
              InputForm(
                verticalPadding: 5.0,
                decompositionNumberHint: "Ваше число",
                decompositionNumberLabel: "Число для декомпозиції",
                stepsHint: "Ваша кількість кроків",
                stepsLabel: "Кількість кроків необхідних для знаходження",
                firstMultiplierLabel: "Перший множник",
                secondMultiplierLabel: "Другий множник",
              ),
            ],
          ),
        ),
      )
    );
  }
}


class _InputData{
  int decompositionNumber;
  int steps;
}

class InputForm extends StatefulWidget {
  final double verticalPadding;
  final String decompositionNumberHint;
  final String decompositionNumberLabel;
  final String stepsHint;
  final String stepsLabel;
  final String firstMultiplierLabel;
  final String secondMultiplierLabel;

  InputForm({Key key,
    @required this.verticalPadding,
    @required this.decompositionNumberLabel,
    @required this.decompositionNumberHint,
    @required this.stepsLabel,
    @required this.stepsHint,
    @required this.firstMultiplierLabel,
    @required this.secondMultiplierLabel,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() => _InputFormState(
    verticalPadding: verticalPadding,
    decompositionNumberHint: decompositionNumberHint,
    decompositionNumberLabel: decompositionNumberLabel,
    stepsHint: stepsHint,
    stepsLabel: stepsLabel,
    firstMultiplierLabel: firstMultiplierLabel,
    secondMultiplierLabel: secondMultiplierLabel,
  );

}

class _InputFormState extends State<InputForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _InputData data = _InputData();

  final double verticalPadding;
  final String decompositionNumberHint;
  final String decompositionNumberLabel;
  final String stepsHint;
  final String stepsLabel;
  final String firstMultiplierLabel;
  final String secondMultiplierLabel;
  TextEditingController textPController = TextEditingController();
  TextEditingController textQController = TextEditingController();

  _InputFormState({
    @required this.verticalPadding,
    @required this.decompositionNumberLabel,
    @required this.decompositionNumberHint,
    @required this.stepsLabel,
    @required this.stepsHint,
    @required this.firstMultiplierLabel,
    @required this.secondMultiplierLabel,
  }) : super();

  void submit() async{
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      var map = {
        "decompositionNumber": data.decompositionNumber,
        "steps": data.steps
      };
      List<int> result = await compute(fermaDecomposition, map);
      if(result == null){
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Не можна знайти множники за данну кількість кроків!"),
        ));
      }
      else{
        int p = result[0];
        int q = result[1];
        int stepsToPerform = result[2];

        textPController.text = p.toString();
        textQController.text = q.toString();

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Операція виконана за $stepsToPerform кроків!"),
        ));
      }
    }
  }

  int _validateInt(String value) {
    int iValue;
    try {
      iValue = int.parse(value);
    } catch (e) {
    return null;
    }
    return iValue;
  }

  String _validateN(String value){
    int iValue = _validateInt(value);
    if (iValue == null){
      return 'Некоректний ввід! Має бути integer!';
    }
    if (iValue < 1){
      return 'Некоректний ввід! Число має бути більше 1!';
    }
    if (iValue % 2 == 0){
      return 'Некоректний ввід! Число має бути непарним!';
    }
    return null;
  }

  String _validateSteps(String value){
    int iValue = _validateInt(value);
    if (iValue == null){
      return 'Некоректний ввід! Має бути integer!';
    }
    if(iValue < 0){
      return 'Некоректний ввід! Число має бути більше 0!'
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> rows = [
      TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          validator: this._validateN,
          onSaved: (String value) {
            this.data.decompositionNumber = int.parse(value);
          },
          decoration: InputDecoration(
              hintText: this.decompositionNumberHint,
              labelText: this.decompositionNumberLabel
          )
      ),
      TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          validator: this._validateSteps,
          onSaved: (String value) {
            this.data.steps = int.parse(value);
          },
          decoration: InputDecoration(
              hintText: this.stepsHint,
              labelText: this.stepsLabel
          )
      ),
      TextFormField(
          enabled: false,
          controller: textPController,
          decoration: InputDecoration(
            labelText: this.firstMultiplierLabel,
          )
      ),
      TextFormField(
          enabled: false,
          controller: textQController,
          decoration: InputDecoration(
            labelText: this.secondMultiplierLabel,
          )
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          child: Text(
            'Виконати',
            style: TextStyle(
                color: Colors.white
            ),
          ),
          onPressed: this.submit,
          color: Colors.blue,
        ),
      ),
    ];

    return Container(
        child: Form(
          key: this._formKey,
          child: Expanded(
            child: ListView(
              children: rows,
            ),
          )
        )
    );
  }
}


class Title extends StatelessWidget{
  final String title;
  final String description;

  Title({Key key, @required this.title, @required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    this.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  this.description,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


