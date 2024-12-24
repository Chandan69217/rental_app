import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';
import '../../custom_paints/circular_curve.dart';
import '../../utilities/color_theme.dart';

class AttendanceScreen extends StatefulWidget {
  final bool enableBack;
  final VoidCallback? onBackPressed;
  AttendanceScreen({this.enableBack = false, this.onBackPressed});
  @override
  State<StatefulWidget> createState() => _FeeScreenStates();
}

class _FeeScreenStates extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.Blue,
        title: Text(
          'Attendance',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: ColorTheme.Snow_white),
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
          child: SingleChildScrollView(
        padding: EdgeInsets.all(16.ss),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _punchCard(),
            SizedBox(height: 10.ss,),
            const Text('Last Attendance',textAlign: TextAlign.start,),
            Container(
              padding: EdgeInsets.symmetric(vertical:  12.ss),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Card(
                    elevation: 2.ss,
                    child: ListTile(
                          title: Text('Hello'),
                        ),
                  )),
            )
          ],
        ),
      )),
    );
  }

  Widget _punchCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: ColorTheme.Gray,
              blurRadius: 10.ss,
              spreadRadius: 3.ss,
            ),
          ],
          borderRadius: BorderRadius.circular(14.ss),
          color: ColorTheme.Blue.withOpacity(0.95)),
      child: CustomPaint(
        painter: CircularWave(
            waveColor: ColorTheme.Snow_white,
            waveHeight: 60,
            waveLength: 550,
            phaseShift: 1),
        child: Padding(
          padding: EdgeInsets.all(12.ss),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50.ss),
                        child: Image.asset(
                          'assets/hotels_images/profile_pic.webp',
                          fit: BoxFit.cover,
                          width: 50.ss,
                          height: 50.ss,
                        )),
                    SizedBox(
                      width: 10.ss,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chandan Sharma',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorTheme.Snow_white),
                          ),
                          Text(
                            'Building: 12A | Room No: 56',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: ColorTheme.Ghost_White),
                          ),
                          SizedBox(
                            height: 5.ss,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.ss,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 8.ss),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'In : 23-Dec-2024 11:17 AM',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: ColorTheme.Snow_white),
                              ),
                              Text('Out : N/A',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: ColorTheme.Snow_white)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Punch Out'),
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.red),
                                foregroundColor: WidgetStatePropertyAll(
                                    ColorTheme.Snow_white)),
                          ),
                        )
                      ],
                    ))
              ]),
        ),
      ),
    );
  }
}
