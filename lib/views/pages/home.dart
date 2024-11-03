import 'package:bdd/views/pages/item_list_view.dart';
import 'package:bdd/views/tiles/list_tile.dart';
import 'package:bdd/views/widgets/add_dialog.dart';
import 'package:flutter/material.dart';

import '../../models/wish_list.dart';
import '../../services/database_helper.dart';
import '../widgets/custom_appbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<WishList> wishLists = [];

  @override
  void initState() {
    getWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleString: "Liste de souhaits",
        buttonTitle: "Ajouter",
        callback: addWishList,
      ),
      body: ListView.separated(
          itemBuilder: ((context, index) {
            final wishList = wishLists[index];
            return WishListTile(
                wishList: wishList,
                onPressed: onListPressed,
                onDeleted: onDeleteWish);
          }),
          separatorBuilder: ((context, index) => const Divider()),
          itemCount: wishLists.length),
    );
  }

  getWishList() async {
    final fromDb = await DatabaseClient().allLists();
    setState(() {
      wishLists = fromDb;
    });
  }

  addWishList() async {
    await showDialog(
        context: context,
        builder: (context) {
          final controller = TextEditingController();
          return AddDialog(
              controller: controller,
              onCancel: handleCloseDialog,
              onValidate: (() {
                Navigator.pop(context);
                if (controller.text.isEmpty) return;
                //ajouter a la DB et rafraichir la liste
                DatabaseClient()
                    .addWishList(controller.text)
                    .then((success) => getWishList());
              }));
        });
  }

  handleCloseDialog() {
    Navigator.pop(context);
    FocusScope.of(context).unfocus(); //fermer le clavier si ouvert
  }

  onListPressed(WishList wishList) {
    final next = ItemListView(wishList: wishList);
    Navigator.push(context, MaterialPageRoute(builder: (context) => next));
  }

  onDeleteWish(WishList wishList) {
    DatabaseClient().deleteWishList(wishList).then((success) {
      getWishList();
    });
  }
}
