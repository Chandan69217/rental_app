import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

void alertDialog({required BuildContext contextParent, String title = 'No internet connection',bool enable = true}) {
  showDialog(
      context: contextParent,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 12.ss,),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal),
                ),
              ),
              TextButton(onPressed: enable ?() {
                Navigator.of(context).pop();
                Navigator.of(contextParent).pop();
              }:null, child: const Text('ok'))
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.ss)),
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
        );
      });
}
