import 'package:flutter/material.dart';
import 'package:score_board/views/commons/decorations.dart';
import 'package:score_board/views/widgets/flat_rounded_button.dart';
import 'package:score_board/views/widgets/player_type_radio_group.dart';

class SecondTeamPlayers extends StatefulWidget {
  final Function onNextPress;

  const SecondTeamPlayers({Key key, @required this.onNextPress}) : super(key: key);

  @override
  _SecondTeamPlayersState createState() => _SecondTeamPlayersState();
}

class _SecondTeamPlayersState extends State<SecondTeamPlayers> {
  List<int> playerTypes = new List<int>(11);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) {
        return SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 11,
                itemBuilder: (_, index) {
                  return new Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: generalCardDecoration,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "First Name",
                                  filled: false,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Last Name",
                                  filled: false,
                                ),
                              ),
                            )
                          ],
                        ),
                        PlayerTypeRadioGroup(
                          groupVale: playerTypes[index],
                          onChange: (newValue) {
                            setState(() {
                              playerTypes[index] = newValue;
                            });
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlatRoundedButton(
                  title: "Next",
                  onPress: widget.onNextPress,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
