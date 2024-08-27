import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var countryValue;
  var stateValue;
  var cityValue;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            CSCPicker(
              dropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border:Border.all(color: Colors.grey.shade300, width: 1)),
              layout: Layout.vertical,
              onCountryChanged: (value) {
                setState(() {
                  countryValue = value;
                });
              },
              onStateChanged:(value) {
                setState(() {
                  stateValue = value;
                });
              },
              onCityChanged:(value) {
                setState(() {
                  cityValue = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context,
                        cityValue,
                      );
                    },
                    child: const Text('Get Weather'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
