import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/helpers/constants.dart';
import 'package:score_board/utils/validators.dart';
import 'package:score_board/viewmodels/match_config_viewmodel.dart';
import 'package:score_board/views/commons/decorations.dart';
import 'package:score_board/views/widgets/flat_rounded_button.dart';
import 'package:score_board/views/widgets/player_type_radio_group.dart';

class FirstTeamPlayers extends StatefulWidget {
  final Function onNextPress;

  const FirstTeamPlayers({Key key, @required this.onNextPress})
      : super(key: key);
  @override
  _FirstTeamPlayersState createState() => _FirstTeamPlayersState();
}

class _FirstTeamPlayersState extends State<FirstTeamPlayers> {
  final _matchFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) {
        return SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Consumer<MatchConfigViewModel>(
            builder: (_, configViewModel, __) {
              return Form(
                key: _matchFormKey,
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: configViewModel.numberOfPlayer,
                      itemBuilder: (_, index) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                                      validator: Validator.nameValidator,
                                      initialValue: configViewModel
                                          .firstTeamFirstName[index],
                                      onSaved: (currentValue) {
                                        configViewModel.changePlayerName(
                                            currentValue,
                                            NameType.FIRST,
                                            TeamNo.FIRST,
                                            index);
                                      },
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
                                      validator: Validator.nameValidator,
                                      initialValue: configViewModel
                                          .firstTeamLastName[index],
                                      onSaved: (currentValue) {
                                        configViewModel.changePlayerName(
                                            currentValue,
                                            NameType.LAST,
                                            TeamNo.FIRST,
                                            index);
                                      },
                                    ),
                                  )
                                ],
                              ),
                              PlayerTypeRadioGroup(
                                groupValue:
                                    configViewModel.firstTeamPlayerType[index],
                                onChange: (newType) {
                                  configViewModel.changePlayerType(
                                      newType, TeamNo.FIRST, index);
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
                        onPress: () {
                          if (_matchFormKey.currentState.validate()) {
                            _matchFormKey.currentState.save();
                            widget.onNextPress();
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
