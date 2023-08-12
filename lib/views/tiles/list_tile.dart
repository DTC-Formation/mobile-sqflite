import 'package:flutter/material.dart';

import '../../models/wish_list.dart';

class WishListTile extends StatelessWidget {
  final WishList wishList;
  Function(WishList) onPressed;
  Function(WishList) onDeleted;
  WishListTile(
      {super.key,
      required this.wishList,
      required this.onPressed,
      required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(wishList.name),
      onTap: (() => onPressed(wishList)),
      trailing: IconButton(
          onPressed: (() => onDeleted(wishList)),
          icon: const Icon(Icons.delete)),
    );
  }
}
