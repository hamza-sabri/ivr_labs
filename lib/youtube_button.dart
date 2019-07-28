import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class YoutubeButton extends StatefulWidget {
  String url;

  YoutubeButton({Key key, this.url}) : super(key: key);

  @override
  _YoutubeButtonState createState() => _YoutubeButtonState();
}

class _YoutubeButtonState extends State<YoutubeButton> {
  @override
  Widget build(BuildContext context) {
    if(widget.url == null){
      return Text('');
    }
    return RaisedButton(
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
      ),
      color: Colors.red,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => YoutubePage(
                url: widget.url,
              ),
            ));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

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
