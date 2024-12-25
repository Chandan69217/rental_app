import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
          child: Padding(
            padding: EdgeInsets.all(16.ss),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _punchCard(),
                SizedBox(height: 10.ss,),
                const Text('Last Attendance',textAlign: TextAlign.start,),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical:  12.ss),
                    child: ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Card(
                          elevation: 2.ss,
                          child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('In : 10:34 AM'),
                                    Text('Out : 4:23 PM'),
                                  ],
                                ),
                            trailing: Text('23-Dec-24'),
                              ),
                        )),
                  ),
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
                    Column(
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
                  ],
                ),
                SizedBox(
                  height: 8.ss,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 8.ss),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
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
                        ElevatedButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.red),
                              foregroundColor: WidgetStatePropertyAll(
                                  ColorTheme.Snow_white)),
                          child: Text('Punch Out'),
                        )
                      ],
                    ))
              ]),
        ),
      ),
    );
  }
}
