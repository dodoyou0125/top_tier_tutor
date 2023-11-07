import 'package:flutter/material.dart';

import '../building app/colors.dart';

Future<dynamic> showPaymentDialog(BuildContext context, bool flag) async {
  await showDialog(
    context: context,
    builder: (_) {
      return payment_dialog(flag: flag);
    },
  );
}

class payment_dialog extends StatefulWidget {
  payment_dialog({this.flag});
  final flag;

  @override
  State<payment_dialog> createState() => _payment_dialogState();
}

class _payment_dialogState extends State<payment_dialog> {
  bool _payment_final_check = false;

  void initState() {
    super.initState();
    _payment_final_check = widget.flag;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      backgroundColor: Colors.white,
      title: Text(
        '결제하시겠습니까?',
        style: TextStyle(
          fontFamily: 'NanumSquare',
          color: TTT_dark_blue,
          fontSize: 25.0,
          fontWeight: FontWeight.w900,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _payment_final_check = true;
            Navigator.pop(context, _payment_final_check);
          },
          child: Text(
            '확인',
            style: TextStyle(
              fontFamily: 'NanumSquare',
              color: TTT_dark_blue,
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        )
      ],
    );
  }
}
