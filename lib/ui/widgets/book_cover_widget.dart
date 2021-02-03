import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BookCoverWidget extends StatelessWidget {
  BookCoverWidget(
      {@required this.width,
      @required this.height,
      @required this.imageLink,
      Key key})
      : assert(width != null && height != null),
        super(key: key);

  final double width;
  final double height;
  final String imageLink;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: imageLink != null
                  ? NetworkImage(imageLink)
                  : AssetImage("images/book-placeholder.jpg"),
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade600, blurRadius: 32)
            ]));
  }
}
