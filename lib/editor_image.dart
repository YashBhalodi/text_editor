import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
    @override
    Future<String> pickImage(ImageSource source) async {
        final file = await ImagePicker.pickImage(source: source);
        if (file == null) return null;
        // We simply return the absolute path to selected file.
        return file.uri.toString();
    }

    @override
    Widget buildImage(BuildContext context, String key) {
        // TODO: implement buildImage
        final file = File.fromUri(Uri.parse(key));
        /// Create standard [FileImage] provider. If [key] was an HTTP link
        /// we could use [NetworkImage] instead.
        final image = FileImage(file);
        return Image(image: image);
    }

    @override
    // TODO: implement cameraSource
    ImageSource get cameraSource => ImageSource.camera;

    @override
    // TODO: implement gallerySource
    ImageSource get gallerySource => ImageSource.gallery;
}