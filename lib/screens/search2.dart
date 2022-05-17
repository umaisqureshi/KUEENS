import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';



class Search2 extends StatefulWidget {

  @override
  _Search2State createState() => _Search2State();
}

class _Search2State extends State<Search2> {
  String input='';
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();
  PaginateFilterChangeListener paginateFilterChangeListener = PaginateFilterChangeListener();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Card(
          child: TextField(
            onChanged: (value){
              setState(() {
                input = value;
              });
              if(input.isNotEmpty) {
                paginateFilterChangeListener.searchTerm = input;
              }else{
                refreshChangeListener.refreshed = true;
              }
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.black,),
                contentPadding: EdgeInsets.only(top: 17),
                hintText: "Search"),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshChangeListener.refreshed = true;
        },
        child: PaginateFirestore(
          itemBuilderType: PaginateBuilderType.listView,
          emptyDisplay: Center(
              child: CircularProgressIndicator()),
          bottomLoader: Center(
              child: CircularProgressIndicator()),
          initialLoader: Center(
              child: CircularProgressIndicator()),
          itemBuilder: (index, context, documentSnapshot) {
           return  Padding(
             padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
             child: Material(
               elevation: 4.0,
               child: ListTile(
                 trailing: IconButton(onPressed: (){
                   Navigator.of(context)
                       .pushNamed('/itemDetail', arguments: documentSnapshot);
                 },icon: Icon(Icons.more_vert),),
                 leading:  Image.network(
                   documentSnapshot.data()['images'][0],
                   width: 80,
                   height: 80,
                   fit: BoxFit.cover,
                 ),
                 title: Text(
                   documentSnapshot.data()['title'],
                   style: TextStyle(
                       fontSize: 14,
                       color: Colors.black,
                       fontWeight: FontWeight.bold
                   ),
                   textAlign: TextAlign.left,
                 ),
                 subtitle:  Text(
                   documentSnapshot.data()['desc'],
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
          query:
          FirebaseFirestore.instance
              .collection('Post'),
          listeners: [
            refreshChangeListener,
            paginateFilterChangeListener
          ],
         // isLive: true,
        ),
      ),
    );
  }
}
