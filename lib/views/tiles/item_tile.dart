import 'dart:io';

import 'package:bdd/models/item.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  const ItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(item.name,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
          if (item.image != null)
            Container(
                padding: EdgeInsets.all(8.0),
                child: Image.file(
                  File(item.image!),
                  width: MediaQuery.sizeOf(context).width / 2,
                )),
          Text("prix : ${item.price} MGA"),
          Text("magasin : ${item.shop}"),
        ],
      ),
    );
  }
}
