import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:kueens/widgets/FilterWidget.dart';
import 'package:restcountries/restcountries.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String name = "";
  var api = RestCountries.setup('b572c343f4faa8a6e6ae270253c04faf');
  List<Country> countries;
  List<Region> regions;
  List<City> cities;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedId = 0;
  void _onValueChange(value) {
    setState(() {
      _selectedId = value;
    });
  }

  getCountries ()async{
    countries =  await api.getCountries();
    print("Countries :");
    for(int i=0 ; i<countries.length; i++){
      print("${countries[i].name} : ${countries[i].code}");
    }
  }

  getRegions (code)async{
    regions =  await api.getRegions(countryCode: code, );
    print("Regions :");
    for(int i=0 ; i<regions.length; i++){
      print("${regions[i].country} : ${regions[i].region}");
    }
  }

  getCities (countryCode,region)async{
    cities =  await api.getCities(countryCode: countryCode, region: region);
    print("Cities :");
    for(int i=0 ; i<cities.length; i++){
      print("${cities[i].country} : ${cities[i].city}");
    }
  }


  @override
  void initState() {
    super.initState();
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Card(
          child: TextField(
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primaryColor,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              suffixIcon: InkWell(onTap: (){
                return _scaffoldKey.currentState.openEndDrawer();
                    },child: Icon(Icons.filter_list)),
                prefixIcon: Icon(Icons.search,color: Colors.white,), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
                .collection('Post')
        .where("tags",arrayContains: "#${name.toLowerCase()}")
            /* .orderBy('title')
            .startAt([name.toUpperCase()])
            .endAt([name.toLowerCase() + '\uf8ff'])*/
            .snapshots()
            : FirebaseFirestore.instance.collection("Post").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      child: Material(
                        elevation: 4.0,
                        child: ListTile(
                          trailing: IconButton(onPressed: (){
                            Navigator.of(context)
                                .pushNamed('/itemDetail', arguments: snapshot.data.docs[index]);
                          },icon: Icon(Icons.more_vert),),
                          leading:  Image.network(
                            data.data()['images'][0],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            data.data()['title'],
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.left,
                          ),
                          subtitle:  Text(
                            data.data()['desc'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600]
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    /*  endDrawer: Drawer(
        elevation: 6,
        child: FilterWidget(),
      ),*/
    );
  }
}
class MyDialog extends StatefulWidget {
  const MyDialog({this.onValueChange, this.initialValue});

  final int initialValue;
  final void Function(dynamic) onValueChange;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  int _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Confirm Your Search Filter"),
      children: <Widget>[
        _myRadioButton(
          title: "City",
          value: 0,
          onChanged: (newValue) {
            setState(() {
              _selectedId = newValue;
            });
            widget.onValueChange(newValue);
          },
        ),
        _myRadioButton(
          title: "Country",
          value: 1,
          onChanged: (newValue) {
            setState(() {
              _selectedId = newValue;
            });
            widget.onValueChange(newValue);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Membership',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _myRadioButton(
          title: "Silver",
          value: 2,
          onChanged: (newValue) {
            setState(() {
              _selectedId = newValue;
            });
            widget.onValueChange(newValue);
          },
        ),
        _myRadioButton(
          title: "Gold",
          value: 3,
          onChanged: (newValue) {
            setState(() {
              _selectedId = newValue;
            });
            widget.onValueChange(newValue);
          },
        ),
        _myRadioButton(
          title: "Platinum",
          value: 4,
          onChanged: (newValue) {
            setState(() {
              _selectedId = newValue;
            });
            widget.onValueChange(newValue);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Active #Tags',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _myRadioButton(
          title: "Tag",
          value: 5,
          onChanged: (newValue) {
            setState(() {
              _selectedId = newValue;
            });
            widget.onValueChange(newValue);
          },
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'ok',
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _selectedId,
      onChanged: onChanged,
      title: Text(title),
    );
  }
}
