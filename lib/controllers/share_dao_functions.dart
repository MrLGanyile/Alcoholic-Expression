import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

bool showProgressBar = false;

// Upload an image into a particular firebase storage bucket.
Future<String> uploadResource(File resource, String storagePath) async{
    
  Reference reference = FirebaseStorage.instance.ref()
  .child(storagePath);

  UploadTask uploadTask = reference.putFile(resource);
  TaskSnapshot taskSnapshot = await uploadTask;

  String downloadURL = await taskSnapshot.ref.getDownloadURL();
  return downloadURL;
  
}
