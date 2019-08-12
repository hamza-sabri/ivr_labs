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
    if (widget.url == null) {
      return Text('');
    }
    return _myYoutubeButton();
  }

  Widget _myYoutubeButton() {
    return RaisedButton(
      child: _myIcon(),
      color: Colors.red,
      onPressed: () {
        _myNavigatore();
      },
      shape: _myCustomShape(),
    );
  }

  void _myNavigatore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YoutubePage(
          url: widget.url,
        ),
      ),
    );
  }

  Icon _myIcon() {
    return Icon(
      Icons.play_arrow,
      color: Colors.white,
    );
  }

  _myCustomShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
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
