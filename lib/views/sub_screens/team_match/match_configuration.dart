import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:score_board/views/widgets/app_slider.dart';
import 'package:score_board/views/widgets/flat_rounded_button.dart';

class MatchConfiguration extends StatefulWidget {
  final Function onNextPress;

  const MatchConfiguration({Key key, @required this.onNextPress}) : super(key: key);
  @override
  _MatchConfigurationState createState() => _MatchConfigurationState();
}

class _MatchConfigurationState extends State<MatchConfiguration> {
  int playersPerTeam = 4;
  int numberOfOver = 10;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint){
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: "Name of the first Team"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "Name of the second Team"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Number of Player: $playersPerTeam Players"),
                          AppSlider(
                            min: 3,
                            max: 11,
                            value: playersPerTeam,
                            onChange: (double newValue){
                              setState(() {
                                playersPerTeam = newValue.toInt();
                              });
                            },
                          ),
                          Text("Number of Over: $numberOfOver Overs"),
                          AppSlider(
                            min: 6,
                            max: 20,
                            value: numberOfOver,
                            onChange: (double newValue){
                              setState(() {
                                numberOfOver = newValue.toInt();
                              });
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "Maximum Over/Bowler"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    FlatRoundedButton(
                      title: "Next",
                      onPress: widget.onNextPress,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


