import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_app/data.dart';
import 'package:bitcoin_app/services/crypto_exchange_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCurrency = 'DOP';
  Map<String, String> conversionResults = {};
  final CryptoExchangeService _cryptoExchangeService = CryptoExchangeService();

  DropdownButton<String> getAndroidDropDownButtom() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currencyList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          updateConversionRates();
        });
      },
    );
  }

  CupertinoPicker getIOSCupertinoPicker() {
    List<Text> pickerItems = [];
    for (String currency in currencyList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (value) {
        setState(() {
          selectedCurrency = currencyList[value];
          updateConversionRates();
        });
      },
      children: pickerItems,
    );
  }

  void updateConversionRates() async {
    if (selectedCurrency != null) {
      Map<String, String> newResults = {};
      for (String crypto in cryptoList) {
        double? rate = await _cryptoExchangeService.getExchangeRate(crypto, selectedCurrency!);
        newResults[crypto] = rate != null
            ? '1 $crypto = ${rate.toStringAsFixed(2)} $selectedCurrency'
            : 'Failed to fetch rate';
      }
      setState(() {
        conversionResults = newResults;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateConversionRates();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Crypto Converter'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: ListView.builder(
                  itemCount: cryptoList.length,
                  itemBuilder: (context, index) {
                    String crypto = cryptoList[index];
                    return Card(
                      color: Colors.lightBlueAccent,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                        child: Text(
                          conversionResults[crypto] ?? 'Loading...',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 150,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30),
              color: Colors.lightBlue,
              child: Platform.isIOS ? getIOSCupertinoPicker() : getAndroidDropDownButtom(),
            ),
          ],
        ),
      ),
    );
  }
}
