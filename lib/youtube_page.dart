import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';


/*
this class is to mange the youtube page and anything in it  
*/
class YoutubePage extends StatelessWidget {
  String url;
  YoutubePage({this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: YoutubePlayer(
        context: context,
        source: url,
        quality: YoutubeQuality.HD,
      ),
    );
  }
}
