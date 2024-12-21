import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';
import '../../utilities/color_theme.dart';

class FeeScreen extends StatefulWidget {
  final bool enableBack;
  final VoidCallback? onBackPressed;
  FeeScreen({this.enableBack = false, this.onBackPressed});
  @override
  State<StatefulWidget> createState() => _FeeScreenStates();
}

class _FeeScreenStates extends State<FeeScreen> {
  final List<Map<String, dynamic>> _fees = [
    {'month_of': 'Feb 2024', 'fee': 2400.00},
    {'month_of': 'March 2024', 'fee': 3200.00}
  ];
  final Set<int> _getSelection = {};
  double _totalAmount = 0.00;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.Blue,
      appBar: AppBar(
        backgroundColor: ColorTheme.Blue,
        title: Column(
          children: [
            RichText(
              text: TextSpan(
                  text: 'Pay Fee',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: ColorTheme.Snow_white),
                  children: [
                    TextSpan(text: '\n'),
                    TextSpan(
                        text: 'Building: 12A | Room No: 56',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: ColorTheme.Snow_white, fontSize: 10.fss))
                  ]),
            ),
          ],
        ),
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
              padding: EdgeInsets.only(left: 24.ss, right: 24.ss, top: 35.ss),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.ss,bottom: 5.ss),
                    child: RichText(
                        text: TextSpan(
                            text: 'Payments',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                            children: [
                              const TextSpan(text: '\n'),
                              TextSpan(
                                  text: 'Select dues payments',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall)
                            ])),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 2,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _FeeExpansionTile(
                              fees: _fees[index],
                              toggle:
                              _getSelection.contains(index),
                              onChanged: (value) {
                                _toggleSelection(index);
                              });
                        }),
                  ),
                  Visibility(
                    visible: _totalAmount != 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.ss, vertical: 5.ss),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              elevation: const WidgetStatePropertyAll(0),
                              backgroundColor:
                                  const WidgetStatePropertyAll(ColorTheme.Blue),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.ss),
                                ),
                              )),
                          child: Center(
                            child: Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('Pay ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: ColorTheme.Snow_white,
                                              fontSize: 14.fss)),
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
                                            color: ColorTheme.Snow_white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  _toggleSelection(int index) {
    setState(() {
      if (_getSelection.contains(index)) {
        _totalAmount -= _fees[index]['fee'];
        _getSelection.remove(index);
      } else {
        _totalAmount += _fees[index]['fee'];
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
          title: Text(fees['month_of'],
              style: Theme.of(context).textTheme.bodyMedium),
          subtitle: _expansionChildrenTile(
              rupees: fees['fee'], title: 'Total Amount'),
          expandedAlignment: Alignment.centerLeft,
          childrenPadding:
              EdgeInsets.symmetric(horizontal: 16.ss, vertical: 5.ss),
          children: [
            Stack(alignment: Alignment.center, children: [
              const Divider(),
              Container(
                padding: EdgeInsets.symmetric(horizontal:5.ss),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.ss),
                  color: ColorTheme.Blue,
                ),
                child: Text('Fee Details',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: ColorTheme.Snow_white),),
              )
            ]),
            _expansionChildrenTile(rupees: fees['fee'], title: 'Rent'),
            _expansionChildrenTile(rupees: fees['fee'], title: 'Electricity'),
            _expansionChildrenTile(rupees: fees['fee'], title: 'Water'),
            _expansionChildrenTile(rupees: fees['fee'], title: 'Fooding'),
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
  final double rupees;
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
                '$rupees',
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
