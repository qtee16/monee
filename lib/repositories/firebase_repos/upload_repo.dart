import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadRepo {
  final FirebaseStorage storage;
  UploadRepo({required this.storage});

  Future<String> uploadImage(String id, File imageFile, String imageName, String type) async {
    final pathImage = "images/$type/$id/$imageName";
    final childRef = storage.ref().child(pathImage);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final snapshot = await childRef.putFile(imageFile, metadata);
    return snapshot.ref.getDownloadURL();
  }
}