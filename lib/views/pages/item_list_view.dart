import 'package:bdd/models/wish_list.dart';
import 'package:bdd/views/pages/add_item_view.dart';
import 'package:bdd/views/tiles/item_tile.dart';
import 'package:bdd/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../models/item.dart';
import '../../services/database_helper.dart';

class ItemListView extends StatefulWidget {
  final WishList wishList;

  const ItemListView({super.key, required this.wishList});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  List<Item> items = [];

  @override
  void initState() {
    getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          titleString: widget.wishList.name,
          buttonTitle: '+',
          callback: addNewItem),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1),
          itemBuilder: ((context, index) => ItemTile(item: items[index])),
          itemCount: items.length),
    );
  }

  addNewItem() {
    final next = AddItemView(listId: widget.wishList.id);
    Navigator.push(context, MaterialPageRoute(builder: (context) => next))
        .then((value) => getItems());
  }

  getItems() async {
    DatabaseClient().itemFromWishlist(widget.wishList.id).then((items) {
      setState(() {
        this.items = items;
      });
    });
  }
}
