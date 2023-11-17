import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Model/Currency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:developer' as developer;

main() {
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "dana",
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
          bodySmall: TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.w300),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // English
      ],
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> curreny = [];

  Future getResponse(BuildContext context) async {
    String url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));
    // developer.log(value.body, name: "main");
    if (curreny.isEmpty) {
      if (value.statusCode == 200) {
        _showSnackBar(context, "بروزرسانی اطلاعات با موفقیت انجام شد.");
        developer.log(value.body,
            name: "Response", error: convert.jsonDecode(value.body));

        List jsonList = convert.jsonDecode(value.body);
        if (jsonList.isNotEmpty) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              curreny.add(Currency(
                id: jsonList[i]["id"],
                title: jsonList[i]["title"],
                price: jsonList[i]["price"],
                changes: jsonList[i]["changes"],
                status: jsonList[i]["status"],
              ));

              developer.log("setstate", name: "setstate");
            });
          }
        }
      }
    }

    return value;
  }

  @override
  void initState() {
    super.initState();
    developer.log("initState", name: 'wLifeCycle');
    getResponse(context);
  }

  @override
  Widget build(BuildContext context) {
    developer.log("build", name: 'wLifeCycle');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        actions: [
          const SizedBox(
            width: 8,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Image.asset("assets/images/icon.png")),
          const SizedBox(
            width: 8,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                "قیمت بروز ارز",
                style: Theme.of(context).textTheme.titleLarge,
                // TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
          Expanded(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset("assets/images/menu.png")),
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset("assets/images/question.png"),
                  const SizedBox(
                    width: 8,
                  ),
                  Text("نرخ ارز آزاد چیست؟",
                      style: Theme.of(context).textTheme.titleLarge)
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                child: Text(
                    "نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می کند.",
                    style: Theme.of(context).textTheme.bodySmall),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(1000),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(blurRadius: 2, color: Colors.white)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("نام آزاد ارز",
                          style: Theme.of(context).textTheme.titleMedium),
                      Text("قیمت",
                          style: Theme.of(context).textTheme.titleMedium),
                      Text("تغییر",
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 20 / 41,
                child: ListFutureBuilder(context),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(255, 232, 232, 232)),
                  child: Row(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 16,
                          width: 135,
                          child: TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 202, 193, 255)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(1000)))),
                              onPressed: () {
                                curreny.clear();
                                ListFutureBuilder(context);
                              },
                              icon: const Icon(
                                CupertinoIcons.refresh_bold,
                                color: Colors.black,
                              ),
                              label: const Text(
                                "بروز رسانی",
                                style: TextStyle(color: Colors.black),
                              ))),
                      Expanded(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                  "آخرین بروز رسانی ${getFarsi(_getTime())}"))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> ListFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListviewModel()
            : const Center(child: CircularProgressIndicator());
      },
      future: getResponse(context),
    );
  }

  ListView ListviewModel() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: InformationContainer(position, curreny));
        },
        separatorBuilder: (BuildContext context, int position) {
          if (position % 8 == 0) {
            return const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: AdsContainer(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        itemCount: curreny.length);
  }
}

class AdsContainer extends StatelessWidget {
  const AdsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.red,
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 2, color: Colors.grey)
        ],
        borderRadius: BorderRadius.circular(1000),
      ),
      child: const Center(
        child: Text(
          "advertisment",
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class InformationContainer extends StatelessWidget {
  int position;
  List<Currency> currency;
  InformationContainer(this.position, this.currency, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 1, color: Colors.grey)
        ],
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(currency[position].title!),
          Text(getFarsi(currency[position].price!)),
          Text(getFarsi(currency[position].changes!),
              style: currency[position].status == "p"
                  ? const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)
                  : const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

_showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(
        msg,
      ),
    ),
    backgroundColor: Colors.green,
  ));
}

String _getTime() {
  final now = DateTime.now();

  return "${now.minute} : ${now.hour}";
}

String getFarsi(String number) {
  List en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  List fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (var element in en) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  }
  return number;
}
