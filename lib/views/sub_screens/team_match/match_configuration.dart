import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_board/utils/validators.dart';
import 'package:score_board/viewmodels/match_config_viewmodel.dart';
import 'package:score_board/views/widgets/app_slider.dart';
import 'package:score_board/views/widgets/flat_rounded_button.dart';

class MatchConfiguration extends StatefulWidget {
  final Function onNextPress;

  const MatchConfiguration({Key key, @required this.onNextPress})
      : super(key: key);
  @override
  _MatchConfigurationState createState() => _MatchConfigurationState();
}

class _MatchConfigurationState extends State<MatchConfiguration> {
  final _matchFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Consumer<MatchConfigViewModel>(
                  builder: (_, configViewModel, __) {
                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: Form(
                            key: _matchFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Name of the first Team"),
                                  initialValue: configViewModel.firstTeamName,
                                  validator: Validator.nameValidator,
                                  onSaved: (currentValue) => configViewModel
                                      .changeTeamName(currentValue, 1),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Name of the second Team"),
                                  initialValue: configViewModel.secondTeamName,
                                  validator: Validator.nameValidator,
                                  onSaved: (currentValue) => configViewModel
                                      .changeTeamName(currentValue, 2),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    "Number of Player: ${configViewModel.numberOfPlayer} Players"),
                                AppSlider(
                                  min: 3,
                                  max: 11,
                                  value: configViewModel.numberOfPlayer,
                                  onChange:
                                      configViewModel.changeNumberOfPlayer,
                                ),
                                Text(
                                    "Number of Over: ${configViewModel.numberOfOvers} Overs"),
                                AppSlider(
                                  min: 6,
                                  max: 20,
                                  value: configViewModel.numberOfOvers,
                                  onChange: configViewModel.changeNumberOfOver,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Maximum Over/Bowler"),
                                  keyboardType: TextInputType.number,
                                  validator: (currentValue) {
                                    if (currentValue.isEmpty)
                                      return "Maximum Over/Bowler can not be empty";
                                    if (int.parse(currentValue) >=
                                        configViewModel.numberOfOvers) {
                                      return "Maximum over per bowler can not be greater than total over.";
                                    }
                                    return null;
                                  },
                                  initialValue: configViewModel.maxOverPerBowler
                                      .toString(),
                                  onSaved: (currentValue) =>
                                      configViewModel.maxOverPerBowler =
                                          int.parse(currentValue),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        FlatRoundedButton(
                          title: "Next",
                          onPress: () {
                            if (_matchFormKey.currentState.validate()) {
                              _matchFormKey.currentState.save();
                              configViewModel.setSizeOfTeamInfo();
                              /// Delayed to reflect the change in view model
                              /// its does not necessary but it will ensure
                              /// next page title will show correct team name
                              Future.delayed(Duration(milliseconds: 100), () {
                                widget.onNextPress();
                              });
                            }
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
