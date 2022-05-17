
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kueens/controller/chat_controller.dart';
import 'package:kueens/model/route_argument.dart';
import 'package:kueens/utils/app_colors.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../model/choose.dart';


class Chat extends StatelessWidget {
  final RouteArgument routeArgument;
  Chat({Key key, @required this.routeArgument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            clipBehavior: Clip.hardEdge,
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
                padding: EdgeInsets.all(15.0),
              ),
              imageUrl: routeArgument.param2,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          routeArgument.param3,
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        ),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: (Choice choice) {
              if (choice.title == 'media') {
                Navigator.of(context)
                    .pushReplacementNamed('/media', arguments: routeArgument);
              } else {}
            },
            itemBuilder: (BuildContext context) {
              return <Choice>[
                Choice(title: 'media', icon: Icons.more_vert),
              ].map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: AppColors.primaryColor,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: ChatScreen(
        peerId: routeArgument.param1,
        peerAvatar: routeArgument.param2,
        peerName: routeArgument.param3,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;

  ChatScreen(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName})
      : super(key: key);

  @override
  State createState() => ChatScreenState(
      peerId: peerId, peerAvatar: peerAvatar, peerName: peerName);
}

class ChatScreenState extends StateMVC<ChatScreen> {
  String peerId;
  String peerAvatar;
  final String peerName;
  ChatController _con;
  ChatScreenState(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName})
      : super(ChatController()) {
    this._con = controller;
  }

  @override
  void initState() {
    super.initState();
    _con.focusNode.addListener(_con.onFocusChange);
    _con.listScrollController.addListener(_con.scrollListener);
    _con.init(peerId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // List of messages
            _con.buildListMessage(peerAvatar),
            _con.buildInput(peerId),
          ],
        ),
        _con.buildLoading()
      ],
    );
  }
}
