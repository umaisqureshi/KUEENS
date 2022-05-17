import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class FilterWidget extends StatefulWidget {

  FilterWidget({Key key,}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends StateMVC<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Filter'),
                  MaterialButton(
                    onPressed: () {
                    },
                    child: Text(
                      'Clear',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                primary: true,
                shrinkWrap: true,
                children: <Widget>[
                  ExpansionTile(
                    title: Text('Search Filter'),
                    children: [
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: false,
                        onChanged: (value) {
                          setState(() {

                          });
                        },
                        title: Text(
                          'City',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ),
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: false,
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        title: Text(
                          'Country',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ),
                    ],
                    initiallyExpanded: true,
                  ),
                  ExpansionTile(
                    title: Text('Membership'),
                    children: [
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        value:false,
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        title: Text(
                          'Silver',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ),
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        value:false,
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        title: Text(
                          'Gold',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ),
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        value:false,
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        title: Text(
                          'Platinum',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      ),
                    ],
                    initiallyExpanded: true,
                  ),
                  ExpansionTile(
                          title: Text('Active #Tags'),
                          children: [
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: false,
                              onChanged: (value) {

                              },
                              title: Text(
                                'Tag',
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                maxLines: 1,
                              ),
                            ),
                          ],
                          initiallyExpanded: true,
                        ),
                ],
              ),
            ),
            SizedBox(height: 15),
            FlatButton(
              onPressed: () {

              },
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
              child: Text(
                'Apply filter',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
