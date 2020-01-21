import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/*
this class is to mange the youtube page and anything in it  
*/
class YoutubePage extends StatelessWidget {
  final String url;

  YoutubePage({this.url});
  @override
  Widget build(BuildContext context) {
    YoutubePlayerController controller = createController();
    controller.play();
    return Scaffold(
      appBar: AppBar(),
      body: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
      ),
    );
  }

  createController() {
    return YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url),
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }
}
