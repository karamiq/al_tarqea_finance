import 'dart:io';
import 'package:al_tarqea_finance/common_lib.dart';
import 'package:al_tarqea_finance/data/services/clients/_clients.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

part 'file_upload_service.g.dart';

@riverpod
FileUplodService fileUploadService(Ref ref) => FileUplodService(ref);

class FileUplodService {
  final Ref ref;
  FileUplodService(this.ref);
  Future<String> uploadFile(File file, {required String path}) async {
    // print('at the service level Uploading file: ${file.path} to path: $path');
    try {
      final fileName = p.basename(file.path);
      final storageRef = FirebaseStorage.instance.ref().child('$path/$fileName');

      final uploadTask = storageRef.putFile(file);

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw (e.toString());
    }
  }
}
