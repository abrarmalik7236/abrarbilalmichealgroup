import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:departure/utils/static_members.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'gift_page_order.dart';
import 'localization/demo_localization.dart';
import 'order_page.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  ShoppingCartPageState createState() => ShoppingCartPageState();
}

class ShoppingCartPageState extends State<ShoppingCartPage> {
  int quantity_cart = 1;
  double totalPrice = 0,
      price_after_discount,
      after_check_code,
      total_price_for_discount;
  var _DiscountCode = TextEditingController();
  String dicount_check = "null", saved_text, key;
  List<Map<String, dynamic>> products = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool gift_check = false, give_to_add = true;

  void initState() {
    super.initState();
    getSpecie();
  }

  check_code(customer_code) async {
    after_check_code = 0;
    total_price_for_discount = 0;
    await Firestore.instance
        .collection("discount_code")
        .snapshots()
        .listen((event_out) async {
      for (int i = 0; i < event_out.documents.length; i++) {
        if (customer_code == event_out.documents[i]['code']) {
          if (event_out.documents[i]['owner_id_admi'] != null) {
            if (event_out.documents[i]['number_of_use'] > 0) {
              if (DateTime.now()
                      .isBefore(event_out.documents[i]['end_date'].toDate()) &&
                  DateTime.now()
                      .isAfter(event_out.documents[i]['start_date'].toDate())) {
                setState(() {
                  key = event_out.documents[i]['key'];
                });

                await Firestore.instance
                    .collection("cart")
                    .document(StaticMembers.userId)
                    .collection("items")
                    .snapshots()
                    .listen((event) {
                  for (int j = 0; j < event.documents.length; j++) {
                    for (int k = 0;
                        k < event_out.documents[i]["owner_id_admi"].length;
                        k++) {
                      if (event.documents[j]["ownerId"] ==
                          event_out.documents[i]["owner_id_admi"][k]) {
                        total_price_for_discount = total_price_for_discount +
                            event.documents[j]["price"];
                      }
                    }
                  }
                  check_discount_price(
                      total_price_for_discount,
                      customer_code,
                      event_out.documents[i]['percent'],
                      event_out.documents[i]['max_discount']);
                });
              }
            }
          } else if (event_out.documents[i]['number_of_use'] > 0) {
            if (DateTime.now()
                    .isBefore(event_out.documents[i]['end_date'].toDate()) &&
                DateTime.now()
                    .isAfter(event_out.documents[i]['start_date'].toDate())) {
              await Firestore.instance
                  .collection("cart")
                  .document(StaticMembers.userId)
                  .collection("items")
                  .snapshots()
                  .listen((event) {
                for (int j = 0; j < event.documents.length; j++) {
                  if (event.documents[j]["ownerId"] ==
                      event_out.documents[i]["owner_id"]) {
                    setState(() {
                      key = event_out.documents[i]['key'];
                    });
                    total_price_for_discount =
                        total_price_for_discount + event.documents[j]["price"];
                  }
                }
                check_discount_price(
                    total_price_for_discount,
                    customer_code,
                    event_out.documents[i]['percent'],
                    event_out.documents[i]['max_discount']);
              });
            }
          }
        }
      }
    });
  }

  check_discount_price(
      total_price_for_discount, customer_code, percent, max_discount) {
    after_check_code = total_price_for_discount * percent;
    if ((after_check_code > max_discount)) {
      setState(() {
        price_after_discount = totalPrice - max_discount;
      });
    } else {
      setState(() {
        price_after_discount = totalPrice - after_check_code;
      });
    }
    setState(() {
      dicount_check = "true";
      saved_text = customer_code;
    });
    if (dicount_check == "null") {
      setState(() {
        dicount_check = "false";
      });
    }
  }

  Future<String> getSpecie() async {
    await Firestore.instance
        .collection("web_cart")
        .document(StaticMembers.userId)
        .get()
        .then((snapshot) {
      setState(() {
        totalPrice = snapshot['totalPrice'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getSpecie();
    });

    products.clear();
    return Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          backgroundColor: HexColor("#37558a"),
          title: Image.asset(
            "images/appbartitle.png",
            width: MediaQuery.of(context).size.width * 0.175,
            height: MediaQuery.of(context).size.height * 0.1,
            fit: BoxFit.fill,
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("web_cart")
                  .document(StaticMembers.userId)
                  .collection("items")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text(snapshot.error.toString())));
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (_, index) {
                      quantity_cart =
                          snapshot.data.documents[index]["quantity"];
                      products.add({
                        "itemId": snapshot.data.documents[index]["product_id"],
                        "itemName": snapshot.data.documents[index]["name"],
                        "itemPrice": snapshot.data.documents[index]["price"],
                        "itemQuantity": quantity_cart,
                        "itemSize": snapshot.data.documents[index]["size"],
                        "ownerId": "ytl0Jl0GXJe5Buults4xAM3pHB42"
                      });

                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network(
                              snapshot.data.documents[index]["picture"],
                              width: 100,
                              height: 100,
                            ),
                            Column(
                              children: [
                                Container(
                                  child: Text(
                                      snapshot.data.documents[index]["name"]),
                                ),
                                Container(
                                  child: Text(
                                    DemoLocalizations.of(context)
                                            .gettranslatedValue(
                                                'Home_page_166') +
                                        snapshot.data.documents[index]["price"]
                                            .toString() +
                                        " ${DemoLocalizations.of(context).gettranslatedValue('Home_page_50')} " +
                                        " ${DemoLocalizations.of(context).gettranslatedValue('Home_page_102')}" +
                                        snapshot.data.documents[index]["size"]
                                            .toString() +
                                        " ML",
                                    style: TextStyle(fontFamily: 'Dubai'),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(0),
                                      child: new IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            if (quantity_cart <
                                                    int.parse(snapshot.data
                                                            .documents[index]
                                                        ["total_quantity"]) &&
                                                give_to_add) {
                                              setState(() async {
                                                give_to_add = false;
                                                quantity_cart++;
                                                await Firestore.instance
                                                    .collection("web_cart")
                                                    .document(
                                                        StaticMembers.userId)
                                                    .collection("items")
                                                    .document(snapshot.data
                                                        .documents[index]["id"])
                                                    .updateData({
                                                  "quantity": quantity_cart
                                                }).whenComplete(() async {
                                                  await Firestore.instance
                                                      .collection("web_cart")
                                                      .document(
                                                          StaticMembers.userId)
                                                      .get()
                                                      .then((doc) async {
                                                    if (doc.data != null) {
                                                      totalPrice = doc[
                                                              "totalPrice"] +
                                                          double.parse(snapshot
                                                                  .data
                                                                  .documents[
                                                              index]["price"]);
                                                      double newPrice = doc[
                                                              "totalPrice"] +
                                                          double.parse(snapshot
                                                                  .data
                                                                  .documents[
                                                              index]["price"]);
                                                      await Firestore.instance
                                                          .collection(
                                                              "web_cart")
                                                          .document(
                                                              StaticMembers
                                                                  .userId)
                                                          .updateData({
                                                        "totalPrice": newPrice
                                                      });
                                                    }
                                                    give_to_add = true;
                                                  });
                                                });
                                              });
                                            }
                                          }),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(0),
                                      child: Text(
                                        "${quantity_cart}",
                                        style: TextStyle(fontFamily: 'Dubai'),
                                      ),
                                    ),
                                    Container(
                                      child: new IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            if (quantity_cart > 1 &&
                                                give_to_add) {
                                              setState(() async {
                                                give_to_add = false;
                                                quantity_cart--;
                                                await Firestore.instance
                                                    .collection("web_cart")
                                                    .document(
                                                        StaticMembers.userId)
                                                    .collection("items")
                                                    .document(snapshot.data
                                                        .documents[index]["id"])
                                                    .updateData({
                                                  "quantity": quantity_cart
                                                }).whenComplete(() async {
                                                  await Firestore.instance
                                                      .collection("web_cart")
                                                      .document(
                                                          StaticMembers.userId)
                                                      .get()
                                                      .then((doc) async {
                                                    if (doc.data != null) {
                                                      totalPrice = doc[
                                                              "totalPrice"] -
                                                          double.parse(snapshot
                                                                  .data
                                                                  .documents[
                                                              index]["price"]);
                                                      double newPrice = doc[
                                                              "totalPrice"] -
                                                          double.parse(snapshot
                                                                  .data
                                                                  .documents[
                                                              index]["price"]);
                                                      await Firestore.instance
                                                          .collection(
                                                              "web_cart")
                                                          .document(
                                                              StaticMembers
                                                                  .userId)
                                                          .updateData({
                                                        "totalPrice": newPrice
                                                      });
                                                    }
                                                    give_to_add = true;
                                                  });
                                                });
                                              });
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Firestore.instance
                                      .collection("web_cart")
                                      .document(StaticMembers.userId)
                                      .collection("items")
                                      .document(
                                          snapshot.data.documents[index]["id"])
                                      .delete();
                                  totalPrice = totalPrice -
                                      (double.parse(snapshot
                                              .data.documents[index]["price"]) *
                                          quantity_cart);
                                  Firestore.instance
                                      .collection("web_cart")
                                      .document(StaticMembers.userId)
                                      .updateData({"totalPrice": totalPrice});
                                })
                          ],
                        ),
                      );
                    });
              }),
        ),
        bottomNavigationBar: Container(
          height: 125,
          margin: EdgeInsets.only(bottom: 17.5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Builder(builder: (context) {
                    getSpecie();
                    if (dicount_check == "null") {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: ListTile(
                          title: Builder(
                            builder: (context) {
                              if (dicount_check != "true") {
                                return Text(
                                  DemoLocalizations.of(context)
                                          .gettranslatedValue('Home_page_99') +
                                      "\n$totalPrice ${DemoLocalizations.of(context).gettranslatedValue('Home_page_50')} ",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontFamily: 'Dubai'),
                                );
                              } else
                                return Text(
                                  DemoLocalizations.of(context)
                                          .gettranslatedValue('Home_page_99') +
                                      "$price_after_discount ${DemoLocalizations.of(context).gettranslatedValue('Home_page_50')} ",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontFamily: 'Dubai', color: Colors.red),
                                );
                            },
                          ),
                        ),
                      );
                    } else if (dicount_check == "true") {
                      return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DemoLocalizations.of(context)
                                        .gettranslatedValue('Home_page_241'),
                                    style: TextStyle(
                                        color: Colors.red, fontFamily: 'Dubai'),
                                  ),
                                  Text(
                                    totalPrice.toString(),
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.red,
                                        fontFamily: 'Dubai'),
                                  ),
                                ],
                              ),
                              Text(
                                DemoLocalizations.of(context)
                                        .gettranslatedValue('Home_page_50') +
                                    price_after_discount.toString(),
                                style: TextStyle(fontFamily: 'Dubai'),
                              ),
                            ],
                          ));
                    } else
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ListTile(
                          title: Builder(
                            builder: (context) {
                              if (dicount_check != "true") {
                                return Text(
                                  DemoLocalizations.of(context)
                                          .gettranslatedValue('Home_page_99') +
                                      "$totalPrice ${DemoLocalizations.of(context).gettranslatedValue('Home_page_50')} ",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontFamily: 'Dubai'),
                                );
                              } else
                                return Text(
                                  DemoLocalizations.of(context)
                                          .gettranslatedValue('Home_page_99') +
                                      "$price_after_discount ${DemoLocalizations.of(context).gettranslatedValue('Home_page_50')} ",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontFamily: 'Dubai', color: Colors.red),
                                );
                            },
                          ),
                        ),
                      );
                  }),
                  Builder(builder: (context) {
                    if (dicount_check != "true") {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: 50,
                        child: TextField(
                          controller: _DiscountCode,
                          style: TextStyle(fontFamily: 'Dubai'),
                          decoration: InputDecoration(
                            labelText: DemoLocalizations.of(context)
                                .gettranslatedValue('Home_page_240'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                    } else
                      return Container(
                        child: Text(
                            "${DemoLocalizations.of(context).gettranslatedValue('Home_page_240')}:\n" +
                                saved_text),
                      );
                  }),
                  Builder(builder: (context) {
                    if (dicount_check != "true") {
                      return FlatButton(
                        minWidth: 0,
                        onPressed: () {
                          check_code(_DiscountCode.text.trim());
                        },
                        child: Text(
                          DemoLocalizations.of(context)
                              .gettranslatedValue('Home_page_238'),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Dubai', fontSize: 16),
                        ),
                      );
                    } else
                      return Container();
                  }),
                ],
              ),
              Container(
                color: Colors.white,
                //alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (gift_check) {
                          setState(() {
                            gift_check = false;
                          });
                        } else {
                          setState(() {
                            gift_check = true;
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        //padding: EdgeInsets.only(bottom: 5),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: gift_check ? Colors.green : Colors.black,
                              width: 2),
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wallet_giftcard_sharp,
                              size: 30,
                              color: gift_check ? Colors.green : Colors.black,
                            ),
                            Text(
                              DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_296'),
                              style: TextStyle(
                                  color:
                                      gift_check ? Colors.green : Colors.black,
                                  fontSize: 14,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  fontFamily: 'Dubai'),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                        child: new MaterialButton(
                          onPressed: () {
                            if (totalPrice != 0) {
                              if (gift_check) {
                                if (dicount_check == "true") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GiftPage(
                                                products: products,
                                                totalPrice: totalPrice + 45.0,
                                                dicount_check: dicount_check,
                                                price_after_discount:
                                                    price_after_discount,
                                                saved_text: saved_text,
                                                discount_key: key,
                                              )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GiftPage(
                                                products: products,
                                                totalPrice: totalPrice + 45.0,
                                                dicount_check: dicount_check,
                                                price_after_discount: 0,
                                                saved_text: "null",
                                                discount_key: key,
                                              )));
                                }
                              } else {
                                if (dicount_check == "true") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderPage(
                                                products: products,
                                                totalPrice: totalPrice + 20.0,
                                                dicount_check: dicount_check,
                                                price_after_discount:
                                                    price_after_discount,
                                                saved_text: saved_text,
                                                discount_key: key,
                                              )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderPage(
                                                products: products,
                                                totalPrice: totalPrice + 20.0,
                                                dicount_check: dicount_check,
                                                price_after_discount: 0,
                                                saved_text: "null",
                                                discount_key: key,
                                              )));
                                }
                              }
                            }
                          },
                          child: new Text(
                            DemoLocalizations.of(context)
                                .gettranslatedValue('Home_page_49'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Dubai'),
                          ),
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
