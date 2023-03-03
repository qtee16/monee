import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../repositories/global_repo.dart';

class MemberInfoViewModel extends ChangeNotifier {
  final globalRepo = GlobalRepo.instance;

  File? imageFile;
  String? firstName;
  String? lastName;

  List<PlatformFile>? _pathsImage;
  String? _extension;
  bool _multiPick = false;

  void reset() {
    imageFile = null;
    firstName = null;
    lastName = null;
    _pathsImage = null;
    _extension = null;
    notifyListeners();
  }

  void changeFirstName(String newName) {
    firstName = newName;
    notifyListeners();
  }

  void changeLastName(String newName) {
    lastName = newName;
    notifyListeners();
  }

  Future<void> selectImage() async {
    _pathsImage = (await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: _multiPick,
      onFileLoading: (FilePickerStatus status) => print(status),
      allowedExtensions: (_extension?.isNotEmpty ?? false)
          ? _extension?.replaceAll(' ', '').split(',')
          : null,
    ))?.files;

    imageFile = File(_pathsImage![0].path!);
    notifyListeners();
  }

  Future<void> updateMemberInfo(String userId) async {
    if (imageFile != null) {
      await globalRepo.updateUserImageURL(userId, imageFile!);
    }
    if (firstName != null) {
      await globalRepo.updateFirstName(userId, firstName!);
    }
    if (lastName != null) {
      await globalRepo.updateLastName(userId, lastName!);
    }
  }
}