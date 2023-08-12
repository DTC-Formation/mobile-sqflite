import 'dart:io';

import 'package:bdd/views/widgets/add_textfield.dart';
import 'package:bdd/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/item.dart';
import '../../services/database_client.dart';

class AddItemView extends StatefulWidget {
  final int listId;
  const AddItemView({super.key, required this.listId});

  @override
  State<AddItemView> createState() => _AddItemViewState();
}

class _AddItemViewState extends State<AddItemView> {
  late TextEditingController nameController;
  late TextEditingController shopController;
  late TextEditingController priceController;
  String? imagePath;

  @override
  void initState() {
    nameController = TextEditingController();
    shopController = TextEditingController();
    priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    shopController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          titleString: 'Ajouter item',
          buttonTitle: 'Valider',
          callback: addPressed),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Nouvel item',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
            Card(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (imagePath == null)
                    ? const Icon(Icons.camera, size: 128)
                    : Image.file(File(imagePath!)),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: (() => takePicture(ImageSource.camera)),
                        icon: const Icon(Icons.camera_alt)),
                    IconButton(
                        onPressed: (() => takePicture(ImageSource.gallery)),
                        icon: const Icon(Icons.photo_library_outlined)),
                  ],
                ),
                AddTextfield(hint: "Nom", controller: nameController),
                AddTextfield(
                    hint: "Prix",
                    controller: priceController,
                    textInputType: TextInputType.number),
                AddTextfield(hint: "Boutique", controller: shopController)
              ],
            ))
          ],
        ),
      ),
    );
  }

  //Ajout d'un item
  addPressed() {
    FocusScope.of(context).requestFocus(FocusNode());
    // si nom est vide, ne rien faire
    if (nameController.text.isEmpty) return;
    Map<String, dynamic> map = {'list': widget.listId};
    map['name'] = nameController.text;
    if (shopController.text.isNotEmpty) map['shop'] = shopController.text;
    double price = double.tryParse(priceController.text) ?? 0.0;
    map['price'] = price;
    if (imagePath != null) map['image'] = imagePath;
    Item item = Item.fromMap(map);
    DatabaseClient().upsert(item).then((value) => Navigator.pop(context));
  }

  takePicture(ImageSource source) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);
    if (xFile != null) {
      setState(() {
        imagePath = xFile.path;
      });
    }
  }
}
