import 'package:flutter/material.dart';
import 'package:monetary_value_converter/http.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Conversor de moeda',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MonetaryConverterWidget());
  }
}

class MonetaryConverterWidget extends StatefulWidget {
  const MonetaryConverterWidget({super.key});
  @override
  State<MonetaryConverterWidget> createState() =>
      _MonetaryConverterWidgetState();
}

class _MonetaryConverterWidgetState extends State<MonetaryConverterWidget> {
  final _formKey = GlobalKey<FormState>();
  double? exchangeRate;
  final dynamic formValues = {'keyA': '', 'keyB': '', 'result': 0.0};
  final http = Http();

  handleSubmit() async {
    _formKey.currentState?.save();
    final Exchangerate? values =
        await http.exchangerate(formValues['keyA'], formValues['keyB']);

    setState(() => exchangeRate = values?.rate);
  }

  @override
  Widget build(BuildContext context) {
    final keyA = (formValues["keyA"] as String).toUpperCase();
    final keyB = (formValues["keyB"] as String).toUpperCase();
    final resultMultiplier = formValues['result'];
    final liquidResult = exchangeRate?.toStringAsFixed(2);
    final parsedResult = exchangeRate != null
        ? ((exchangeRate as double) * formValues['result']).toStringAsFixed(2)
        : null;

    return Scaffold(
        appBar: AppBar(title: const Text("Conversor")),
        body: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text('Digite os códigos das moedas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 200,
                    child: TextFormField(
                      onSaved: (String? value) {
                        formValues['keyA'] = value;
                      },
                      decoration: const InputDecoration(labelText: 'USD'),
                    )),
                SizedBox(
                    width: 200,
                    child: TextFormField(
                      onSaved: (String? value) {
                        formValues['keyB'] = value;
                      },
                      decoration: const InputDecoration(labelText: 'BRL'),
                    )),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: handleSubmit,
              child: const Text("Converter"),
            ),
            const SizedBox(height: 15),
            exchangeRate != null
                ? Text('$keyA vale $liquidResult de $keyB',
                    style: const TextStyle(fontWeight: FontWeight.bold))
                : const Text(''),
            exchangeRate != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          width: 200,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  formValues['result'] = double.parse(value);
                                });
                              }
                            },
                            decoration: InputDecoration(labelText: keyA),
                          )),
                      Text(
                          '$resultMultiplier de $keyA vale $parsedResult $keyB',
                          style: const TextStyle(fontWeight: FontWeight.bold))
                    ],
                  )
                : const Text('')
          ]),
        ));
  }
}
