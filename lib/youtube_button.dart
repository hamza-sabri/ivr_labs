import 'package:flutter/material.dart';
import 'package:ivr_labs/youtube_page.dart';

/* 
this class is to creat the button that have the youtube logo on it 
and give it the functionality to open the youtube player on its page
*/

class YoutubeButton extends StatelessWidget {
  final String url;
  YoutubeButton({this.url});

  //------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Text('');
    }
    return _myYoutubeButton(context);
  }

  //this method returns the rasied button to open the youtube
  Widget _myYoutubeButton(BuildContext context) {
    return RaisedButton(
      child: _myIcon(),
      color: Colors.red,
      onPressed: () {
        _myNavigatore(context);
      },
      shape: _myCustomShape(),
    );
  }

  //customising the shape of the button
  Icon _myIcon() {
    return Icon(
      Icons.play_arrow,
      color: Colors.white,
    );
  }

  //customising the shape of the button
  RoundedRectangleBorder _myCustomShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );
  }

  //this method is to navigate to the youtube player page
  void _myNavigatore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YoutubePage(
          url: url,
        ),
      ),
    );
  }
}
