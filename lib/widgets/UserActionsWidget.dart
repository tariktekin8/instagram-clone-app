import 'package:flutter/material.dart';

class UserActionsWidget extends StatefulWidget {
  const UserActionsWidget({
    Key key,
  }) : super(key: key);

  @override
  _UserActionsWidgetState createState() => _UserActionsWidgetState();
}

class _UserActionsWidgetState extends State<UserActionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _getActionButton(text: "Düzenle", onPressed: () {}),
          _getActionButton(text: "Tanıtımlar", onPressed: () {}),
          _getActionButton(text: "İstatistikler", onPressed: () {}),
        ],
      ),
    );
  }

  _getActionButton({String text, @required Function onPressed}) {
    return FlatButton(
      height: 30,
      minWidth: MediaQuery.of(context).size.width * 0.3,
      color: Colors.black45,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(5),
      ),
      onPressed: onPressed,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            child: Text(
              text,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
