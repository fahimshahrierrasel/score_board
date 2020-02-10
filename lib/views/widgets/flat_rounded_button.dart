import 'package:flutter/material.dart';

class FlatRoundedButton extends StatelessWidget {
  final title;
  final Function onPress;
  final bool fullWidth;
  final bool loading;

  FlatRoundedButton({
    Key key,
    @required this.title,
    @required this.onPress,
    this.fullWidth = true,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? MediaQuery.of(context).size.width : null,
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        disabledColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: loading
              ? SizedBox(
                  height: 18.0,
                  width: 18.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: Colors.white,
                  ),
                )
              : Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
        ),
        onPressed: loading ? null : onPress,
      ),
    );
  }
}
