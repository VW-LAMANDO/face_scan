import 'package:flutter/material.dart';

class CustomDialog extends Dialog {
  String title;
  Widget child;
  String negativeText;
  String positiveText;
  Function onPositivePressEvent;

  CustomDialog({
    @required this.title,
    @required this.child,
    @required this.positiveText,
    @required this.negativeText,
    @required this.onPositivePressEvent,
  });

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Material(
        type: MaterialType.transparency,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              margin: const EdgeInsets.all(12.0),
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        new Center(
                          child: new Text(
                            title,
                            style: new TextStyle(
                              fontSize: 19.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffe0e0e0),
                    height: 1.0,
                  ),
                  new Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minHeight: 50.0),
                    child: new Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: new IntrinsicHeight(
                        child: child,
                      ),
                    ),
                  ),
                  this._buildBottomButtonGroup(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup(BuildContext context) {
    var widgets = <Widget>[];
    if (negativeText != null && negativeText.isNotEmpty)
      widgets.add(_buildBottomCancelButton(context));
    if (positiveText != null && positiveText.isNotEmpty)
      widgets.add(_buildBottomPositiveButton(context));
    return new Flex(
      direction: Axis.horizontal,
      children: widgets,
    );
  }

  Widget _buildBottomCancelButton(BuildContext context) {
    return new Flexible(
      fit: FlexFit.tight,
      child: new FlatButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
        child: new Text(
          negativeText,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPositiveButton(BuildContext context) {
    return new Flexible(
      fit: FlexFit.tight,
      child: new FlatButton(
        onPressed: onPositivePressEvent,
        child: new Text(
          positiveText,
          style: TextStyle(
            color: Color(Colors.teal.value),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
