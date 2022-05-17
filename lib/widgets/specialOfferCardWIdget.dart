import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kueens/blocs/postBloc.dart';
import 'package:kueens/utils/firebase_credentials.dart';

class SpecialOfferCardWidget extends StatefulWidget {
  final String category;
  SpecialOfferCardWidget({this.category});
  @override
  _SpecialOfferCardWidgetState createState() => _SpecialOfferCardWidgetState();
}

class _SpecialOfferCardWidgetState extends State<SpecialOfferCardWidget> {

  Duration _duration = Duration(seconds: 1);
  bool isSwitch = false;

  @override
  void initState() {
    super.initState();
   if(mounted) {
     Future.delayed(_duration,(){
       setState(() {
         isSwitch = !isSwitch;
       });
     });
   }
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllSpecialPosts();
    return Container(
        height: 360,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/pd.png'),
                fit: BoxFit.cover)),
        child: Center(
          child: Stack(
            children: [
              Center(
                child: Container(
                    margin: EdgeInsets.only(
                      left: 18,
                      right: 18,
                    ),
                    height: 210,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(
                              0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        ListTile(
                          title: Text("Special Offer",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          subtitle: Text("Made Specially for you "),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacementNamed(context, '/specialOfferList', arguments: widget.category);
                            },
                            child: Text(
                              "See More",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
              Container(
                child: StreamBuilder(
                    stream: bloc.allSpecialPosts,
                    builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                      return snapshot.hasData?snapshot.data.isEmpty?Center(child: AnimatedSwitcher(duration: Duration(seconds: 1),
                        child:   isSwitch?TextButton.icon(onPressed: null, icon: Icon(Icons.find_in_page), label: Text('Not Found')):CircularProgressIndicator(),)):Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return SpecialOfferItem(data:snapshot.data[i]);
                              },
                              itemCount: snapshot.data.length,
                            ),
                          ),
                        ),
                      ):Container();
                    }
                ),
              ),
            ],
          ),
        ));
  }
}
class SpecialOfferItem extends StatefulWidget {
  final QueryDocumentSnapshot data;
  SpecialOfferItem({this.data});

  @override
  _SpecialOfferItemState createState() => _SpecialOfferItemState();
}

class _SpecialOfferItemState extends State<SpecialOfferItem> {
  bool isFav = false;
  @override
  void initState() {
    super.initState();
    FirebaseCredentials().db.collection("User").doc(FirebaseCredentials().auth.currentUser.uid).collection('Fav').doc(widget.data.data()['productId']).get().then((value){
      if(value.exists){
        setState(() {
          isFav = value.data()['isFav'];
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: Stack(
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: (){
                Navigator.of(context)
                    .pushNamed('/itemDetail', arguments: widget.data);

              },
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.8),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0,
                            1), // changes position of shadow
                      ),
                    ],
                    borderRadius:
                    BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(widget.data.data()['offer']['image']),fit: BoxFit.cover)),
                //child: Image.asset('assets/images/picachu.png'),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child:
            InkWell(
              onTap: (){
                setState(() {
                  isFav = !isFav;
                });
                FirebaseCredentials().db.collection("User").doc(FirebaseCredentials().auth.currentUser.uid).collection('Fav').doc(widget.data.data()['productId']).set({'isFav':isFav},SetOptions(merge: true)).then((value) {
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5,right: 5),
                child: Container(
                  width: 30,
                  height: 30,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.9),
                    child: Icon(
                      isFav ?Icons.favorite :Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ),
            ),),
        ],
      ),
    );
  }
}

