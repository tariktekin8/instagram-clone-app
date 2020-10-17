import 'package:flutter/material.dart';
import 'package:instagram_clone_app/models/User.dart';

class UserInfoDetailWidget extends StatelessWidget {
  const UserInfoDetailWidget({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              children: <TextSpan>[
                TextSpan(text: user.name),
                TextSpan(text: '\n'),
                TextSpan(text: '\n'),
                TextSpan(text: user.profileDescription),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
