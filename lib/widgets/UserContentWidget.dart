import 'package:flutter/material.dart';

class UserContentWidget extends StatefulWidget {
  const UserContentWidget({
    Key key,
  }) : super(key: key);

  @override
  _UserContentWidgetState createState() => _UserContentWidgetState();
}

class _UserContentWidgetState extends State<UserContentWidget>
    with TickerProviderStateMixin {
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    tabController = new TabController(length: 2, vsync: this);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey[700],
                width: 0.5,
              ),
              bottom: BorderSide(
                color: Colors.grey[700],
                width: 0.5,
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.grid_on),
                  onPressed: () {}),
              IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.ondemand_video),
                  onPressed: () {}),
              IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.ondemand_video),
                  onPressed: () {}),
              IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.supervised_user_circle),
                  onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }

  _getGridView() {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 20,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Card(
            elevation: 5.0,
            child: Container(
              alignment: Alignment.center,
              child: Text('Item $index'),
            ),
          ),
        );
      },
    );
  }
}
