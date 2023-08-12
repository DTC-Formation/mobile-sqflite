class WishList {
  int id;
  String name;

  WishList(this.id, this.name);

  //convertir le wish list en fromMap
  WishList.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];
}
