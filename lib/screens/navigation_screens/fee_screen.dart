import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rental_app/model/due_amount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';
import '../../model/consts.dart';
import '../../utilities/color_theme.dart';

class FeeScreen extends StatefulWidget {
  final bool enableBack;
  final VoidCallback? onBackPressed;
  FeeScreen({this.enableBack = false, this.onBackPressed});
  @override
  State<StatefulWidget> createState() => _FeeScreenStates();
}

class _FeeScreenStates extends State<FeeScreen> {
  final Set<int> _getSelection = {};
  double _totalAmount = 0.00;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String,dynamic>>> _getFeeDetails() async {
    List<Map<String, dynamic>> payment = [];
    var uri = Uri.parse(
        'https://appadmin.atharvaservices.com/api/Fee/tenantMonthlyFee');
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString(Consts.TOKEN) ?? '';
    if (token.isEmpty) {
      print('Token is empty');
     // return Future.error('User token is empty');
    }
    try {
      var response = await get(uri, headers: {
        Consts.AUTHORIZATION: 'Bearer $token',
        Consts.CONTENT_TYPE: 'application/json'
      });

      if (response.statusCode == 200) {
        var paymentsData = Map.from(json.decode(response.body));
        print("Received data from network: $paymentsData");
        if (paymentsData.containsKey('payments')) {
          payment = List.from(paymentsData['payments']);
          if (payment.isEmpty) {
            print('payment data is not present in the response body');
            return Future.error('payment data is not present');
          }
          return payment;
        } else {
          print("payment is missing in the response.");
        }
      }
      else {
        print(
            'Data cannot be fetched with response code: ${response.statusCode} reason: ${response.reasonPhrase}');
       return Future.error('Data cannot be fetched with response code: ${response.statusCode} reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred during network request: $e');
      return Future.error('Error occurred during network request: $e');
    }
    return payment;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.Blue,
      appBar: AppBar(
        backgroundColor: ColorTheme.Blue,
        title: Text('Pay Fee',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: ColorTheme.Snow_white),),
        leading: IconButton(
            onPressed: () => widget.enableBack
                ? Navigator.pop(context)
                : widget.onBackPressed!(),
            icon: const Icon(
              Icons.keyboard_arrow_left_outlined,
              color: ColorTheme.Snow_white,
            )),
      ),
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 14,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  padding: EdgeInsets.only(
                      left: 24.ss, right: 24.ss, top: 35.ss),
                  decoration: BoxDecoration(
                      color: ColorTheme.Ghost_White,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, -14.ss),
                          blurRadius: 12.ss,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.ss),
                          topRight: Radius.circular(35.ss))),
                  child: FutureBuilder(future: _getFeeDetails(), builder: (context,snapshot){
                    if(snapshot.hasData){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5.ss),
                            child: RichText(
                                text: TextSpan(
                                    text: 'Payments',
                                    style:
                                    Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                      const TextSpan(text: '\n'),
                                      TextSpan(
                                          text: 'Select dues payments',
                                          style:
                                          Theme.of(context).textTheme.bodySmall)
                                    ])),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return _FeeExpansionTile(
                                      fees:snapshot.data![index],
                                      toggle: _getSelection.contains(index),
                                      onChanged: (value) {
                                        _toggleSelection(index,snapshot.data![index]['feeAmount']);
                                      });
                                }),
                          ),
                          Visibility(
                            visible: _totalAmount != 0,
                            child: Container(
                              padding: EdgeInsets.all(
                                10.ss,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Your onPressed logic here
                                },
                                style: ButtonStyle(
                                    elevation: const WidgetStatePropertyAll(0),
                                    backgroundColor:
                                    const WidgetStatePropertyAll(
                                        ColorTheme.Blue),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(50.ss),
                                      ),
                                    )),
                                child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(vertical: 14.ss),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Pay ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            color: ColorTheme.Snow_white,
                                            fontSize: 14.fss,
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/icons/rupee-icon.webp',
                                          width: 16.ss,
                                          height: 16.ss,
                                          fit: BoxFit.cover,
                                          color: ColorTheme.Snow_white,
                                        ),
                                        Text(
                                          '$_totalAmount',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            fontSize: 14.fss,
                                            color: ColorTheme.Snow_white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }else if(snapshot.hasError){
                      return Center(child: Padding(padding: EdgeInsets.all(16.ss),child: Text(snapshot.error.toString()),),);
                    }else{
                      return Center(child: CircularProgressIndicator(color: ColorTheme.Blue,),);
                    }
                  })
                ),
              ),
            ],
          )),
    );
  }

  _toggleSelection(int index, int amount) {
    setState(() {
      if (_getSelection.contains(index)) {
       _totalAmount -= amount;
        _getSelection.remove(index);
      } else {
       _totalAmount += amount;
        _getSelection.add(index);
      }
      if (_getSelection.isEmpty) {
        _totalAmount = 0.00;
      }
    });
  }


}

class _FeeExpansionTile extends StatelessWidget {
  final Map<String, dynamic> fees;
  final bool toggle;
  final Function(bool? value)? onChanged;
  const _FeeExpansionTile(
      {super.key, required this.fees, required this.toggle, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.ss),
      child: Card(
        elevation: 2.ss,
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.ss))),
          collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.ss))),
          tilePadding: EdgeInsets.only(right: 8.ss),
          collapsedBackgroundColor: ColorTheme.Pole_Blue,
          leading: Checkbox(
              value: toggle,
              activeColor: ColorTheme.Blue,
              onChanged: onChanged),
          title: Text(fees['monthName'],
              style: Theme.of(context).textTheme.bodyMedium),
          subtitle: _expansionChildrenTile(
              rupees: fees['feeAmount'], title: 'Total Amount'),
          expandedAlignment: Alignment.centerLeft,
          childrenPadding:
              EdgeInsets.symmetric(horizontal: 16.ss, vertical: 5.ss),
          children: [
            Stack(alignment: Alignment.center, children: [
              const Divider(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.ss),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.ss),
                  color: ColorTheme.Blue,
                ),
                child: Text(
                  'Fee Details',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: ColorTheme.Snow_white),
                ),
              )
            ]),
            _expansionChildrenTile(rupees: fees['details']['rent'], title: 'Rent'),
            _expansionChildrenTile(rupees: fees['details']['electricity'], title: 'Electricity'),
            _expansionChildrenTile(rupees: fees['details']['water'], title: 'Water'),
            // _expansionChildrenTile(rupees: fees['details'][''], title: 'Fooding'),
            SizedBox(
              height: 5.ss,
            )
          ],
        ),
      ),
    );
  }
}

class _expansionChildrenTile extends StatelessWidget {
  final int rupees;
  final String title;
  const _expansionChildrenTile({required this.rupees, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$title: ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 10.fss)),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/rupee-icon.webp',
                width: 12.ss,
                height: 10.ss,
                fit: BoxFit.cover,
              ),
              Text(
                '${double.parse(rupees.toString())}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.fss),
              )
            ],
          ),
        ),
      ],
    );
  }
}
