import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kueens/utils/app_colors.dart';

class PrivacyPolicyModel {
  String policy;
  String accept;
  String notAccept;
  String details;
  int updateAt;

  PrivacyPolicyModel({this.details, this.accept, this.notAccept, this.policy, this.updateAt});
  bool notNull()=> this.policy!=null && accept!=null && notAccept!=null && details!=null && updateAt!=null;

}

class CreatePrivacyPolicy extends StatefulWidget {
  final DocumentSnapshot snap;
  CreatePrivacyPolicy({Key key, this.snap}) : super(key: key);

  @override
  _CreatePrivacyPolicyState createState() => _CreatePrivacyPolicyState();
}

class _CreatePrivacyPolicyState extends State<CreatePrivacyPolicy> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController enterYourCastlePolicy = TextEditingController();
  TextEditingController accept = TextEditingController();
  TextEditingController notAccept = TextEditingController();
  TextEditingController details = TextEditingController();
  String updateOn = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(mounted){
      setState(() {
        if(widget.snap!=null && widget.snap.data()['shopData'].containsKey('updateAt')){
          int timeInMillis = widget.snap.data()['shopData']['updateAt'];
           var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
           updateOn = DateFormat("dd-MMM-yyyy").format(date);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Polices', style: Theme.of(context).textTheme.headline5),
                RichText(
                  text: TextSpan(
                    text: 'Last Updated on ',
                    style: Theme.of(context).textTheme.caption,
                    children: [TextSpan(
                      text:  '$updateOn',
                        style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    )],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: enterYourCastlePolicy,
                  maxLines: 20,
                  minLines: 10,
                  validator: (input) {
                    if (input.isEmpty)
                      return "Required Field";
                    else
                      return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      hintText: "Enter your Kueen's castle policy"),
                ),
                Divider(),
                Text('Return and Exchange',
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text('I gladly accept Return or Exchange'),
                ),
                SizedBox(
                  height: 3,
                ),
                TextFormField(
                  controller: accept,
                  validator: (input) {
                    if (input.isEmpty)
                      return "Required Field";
                    else
                      return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text('I don\'t accept Return or Exchange'),
                ),
                SizedBox(
                  height: 3,
                ),
                TextFormField(
                  controller: notAccept,
                  validator: (input) {
                    if (input.isEmpty)
                      return "Required Field";
                    else
                      return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text('Return and Exchange details'),
                ),
                SizedBox(
                  height: 3,
                ),
                TextFormField(
                  controller: details,
                  maxLines: 20,
                  minLines: 10,
                  validator: (input) {
                    if (input.isEmpty)
                      return "Required Field";
                    else
                      return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 45,
                    child: RaisedButton(
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          PrivacyPolicyModel privacy = PrivacyPolicyModel(
                            accept: accept.text,
                            details: details.text,
                            notAccept: notAccept.text,
                            policy: enterYourCastlePolicy.text,
                            updateAt: DateTime.now().millisecondsSinceEpoch,
                          );
                          Navigator.of(context).pop(privacy);
                        }
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      color: AppColors.primaryColor,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
