import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FullPhoto extends StatelessWidget {
  final String url;

  FullPhoto({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new FullPhotoScreen(url: url),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => _save(),
        child: Icon(
          Icons.save_alt,
          color: Colors.black,
        ),
      ),
    );
  }

  _save() async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Fluttertoast.showToast(msg: 'image saved $result');
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;

  FullPhotoScreen({Key key, @required this.url}) : super(key: key);

  @override
  State createState() => new FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;

  FullPhotoScreenState({Key key, @required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: PhotoView(imageProvider: NetworkImage(url)));
  }
}
