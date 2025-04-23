import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePickerWidget extends StatefulWidget{
  const UserImagePickerWidget({super.key,required this.transferImage});
  final void Function(File image) transferImage;
  @override
  State<StatefulWidget> createState() {
    return _UserImagePickerWidgetState();
  }
}

class _UserImagePickerWidgetState extends State<UserImagePickerWidget>{
  File? selectedImage;
  void _saveImage() async {
    final image= await ImagePicker().pickImage(source: ImageSource.camera);
    if(image!=null){
      setState(() {
        selectedImage=File(image.path);
        widget.transferImage(selectedImage!);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return selectedImage!=null? GestureDetector(
      onTap: _saveImage,
      child: CircleAvatar(
        radius: 90,
        foregroundImage:FileImage(selectedImage!),
      ),
    ): IconButton(onPressed: _saveImage, icon: const Icon(Icons.account_circle_rounded,size: 200,),);
  }
}