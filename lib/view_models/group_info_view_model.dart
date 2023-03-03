import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:spending_app/exception.dart';

import '../repositories/global_repo.dart';

class GroupInfoViewModel extends ChangeNotifier {
  final globalRepo = GlobalRepo.instance;

  File? imageFile;
  String? name;

  List<PlatformFile>? _pathsImage;
  String? _extension;
  bool _multiPick = false;

  void reset() {
    imageFile = null;
    name = null;
    _pathsImage = null;
    _extension = null;
    notifyListeners();
  }

  void changeName(String newName) {
    name = newName;
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

  Future<void> createNewGroup(String groupName) async {
    if (imageFile != null) {
      await globalRepo.createNewGroup(imageFile!, groupName);
    } else {
      throw ImageNullException();
    }
  }
  
  Future<void> updateGroupInfo(String groupId) async {
    if (imageFile != null) {
      await globalRepo.updateGroupImageURL(groupId, imageFile!);
    }
    if (name != null) {
      await globalRepo.updateGroupName(groupId, name!);
    }
  }

  // Future<void> updateInfo(String id) async {
  //   notifyListeners();
  //   if (imageFile != null) {
  //     await globalRepo.updateImageURL(AppString.userCollection, id, imageFile!, id);
  //   }
  //   if (name != null) {
  //     await globalRepo.updateName(id, name!);
  //   }
  // }
}