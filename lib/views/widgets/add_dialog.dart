import 'package:flutter/material.dart';

class AddDialog extends StatelessWidget {
  final TextEditingController controller;
  VoidCallback onCancel;
  VoidCallback onValidate;

  AddDialog(
      {super.key,
      required this.controller,
      required this.onCancel,
      required this.onValidate});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ajouter une liste"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "Nom de la liste"),
      ),
      actions: [
        TextButton(
            onPressed: onCancel,
            child: const Text(
              "Annuler",
              style: TextStyle(color: Colors.red),
            )),
        TextButton(
            onPressed: onValidate,
            child: const Text(
              "Valider",
              style: TextStyle(color: Colors.green),
            ))
      ],
    );
  }
}
