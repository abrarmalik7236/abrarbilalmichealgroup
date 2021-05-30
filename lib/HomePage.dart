import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:departure/shopping_cart_page.dart';
import 'package:departure/utils/language.dart';
import 'package:departure/utils/static_members.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'localization/demo_localization.dart';
import 'main.dart';


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _userId;
  var ronza_text = TextEditingController(),name_on = TextEditingController(),
      three_name = TextEditingController(), date_of_birthdd = TextEditingController(),
      date_of_birthmm = TextEditingController(), date_of_birthyy = TextEditingController(),
      place_of_birth = TextEditingController(), travel_to = TextEditingController();
  String selected_text = "",selected_color = "",departur ="",_chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  void initState() {
    super.initState();
    get_details();
  }
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  get_details() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('user_id') == null){
      prefs.setString('user_id',getRandomString(15));
      StaticMembers.userId = prefs.getString("user_id");
    }else StaticMembers.userId = prefs.getString("user_id");
    _userId = StaticMembers.userId;
  }
  void _changeLanguage(Language language) {
    MyApp.setlocale(context, Language.getLocale(language.languageCode));
  }
  void _showAlert2(BuildContext context, String text) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.all(15.0),
          title: Text( DemoLocalizations.of(context).gettranslatedValue('Home_page_338'),
              style: TextStyle(fontFamily: 'Dubai')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    DemoLocalizations.of(context).gettranslatedValue('Home_page_337') +
                        Language.getLanguage(text).flag,
                    style: TextStyle(fontFamily: 'Dubai')),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              //height: 45,
              //width: MediaQuery.of(context).size.width*0.23,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () async{
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString(StaticMembers.userId, text);
                  _changeLanguage(Language.getLanguage(text));
                  Navigator.of(context).pop();
                },
                child: Text(
                  DemoLocalizations.of(context).gettranslatedValue('Home_page_9'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Dubai'),
                  textAlign: TextAlign.center,
                ),
                textColor: Colors.grey[850],
                color: Colors.black,
              ),
            ),
            Container(
              //height: 45,
              //width: MediaQuery.of(context).size.width*0.23,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () {
                  //_changeLanguage(Language.getLanguage(text));
                  Navigator.of(context).pop();
                },
                child: Text(
                  DemoLocalizations.of(context).gettranslatedValue('Home_page_8'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Dubai'),
                  textAlign: TextAlign.center,
                ),
                textColor: Colors.grey[850],
                color: Colors.black,
              ),
            ),
          ],
        ));
  }
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#37558a"),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width*0.1,
              //alignment: AlignmentDirectional.centerStart,
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01),
              child: IconButton(
                icon: Icon(Icons.card_travel_rounded,size: 28,),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingCartPage()));
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 3,horizontal: MediaQuery.of(context).size.width*0.01),
              width: MediaQuery.of(context).size.width*0.1,
              height: MediaQuery.of(context).size.height*0.1,
              child: ClipOval(
                child: Image.asset(
                  "images/logo_departure_remove.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.5,
              alignment: Alignment.center,
              child: Image.asset(
                "images/appbartitle.png",
                width: MediaQuery.of(context).size.width*0.175,
                height: MediaQuery.of(context).size.height*0.1,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width * 0.01),
              width: MediaQuery.of(context).size.width * 0.22,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: false,
                  child: DropdownButton(
                    elevation: 0,
                    dropdownColor: Colors.grey[200],
                    onChanged: (Language language) async {
                      _showAlert2(context, language.languageCode);
                    },
                    icon: Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                    items: Language.languageList()
                        .map<DropdownMenuItem<Language>>((lang) =>
                        DropdownMenuItem(
                          value: lang,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                lang.flag,
                                style: TextStyle(fontFamily: 'Dubai'),
                              ),
                            ],
                          ),
                        ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ]
      ),
      /*
      drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors.white70.withOpacity(
                0.84), //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: Drawer(
            child: ListView(
              children: <Widget>[
                InkWell(
                    onTap: () {

                    },
                    child: ListTile(
                      title: Text(
                        "CART",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Dubai'),
                      ),
                      leading:
                      Icon(Icons.local_mall, color: Colors.black, size: 26),
                    )
                ),
              ],
            ),
          )),
          
       */
      body: ListView(
        shrinkWrap: true,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("stores").document("ytl0Jl0GXJe5Buults4xAM3pHB42").collection("products").orderBy("list_number").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text(snapshot.error.toString())));
                }
                return ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    /*
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 5,
                          childAspectRatio: 1,
                          mainAxisSpacing: 20),

                       */
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Builder(builder: (context){
                            if(myLocale.countryCode.toString() == "AE"){
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Text(snapshot.data.documents[index]["name"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontFamily: 'Dubai'),),
                              );
                            }else if(snapshot.data.documents[index]["name_eng"] != null){
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Text(snapshot.data.documents[index]["name_eng"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontFamily: 'Dubai'),),
                              );
                            }else return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Text(snapshot.data.documents[index]["name"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontFamily: 'Dubai'),),
                            );
                          }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network(snapshot.data.documents[index]["picture"],width:MediaQuery.of(context).size.width*0.4,height:MediaQuery.of(context).size.width*0.4,fit: BoxFit.fill,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Builder(builder: (context){
                                    if(myLocale.countryCode.toString() == "AE"){
                                      return Container(
                                        alignment: Alignment.center,
                                        //height: 30,
                                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.width*0.2,maxWidth: MediaQuery.of(context).size.width*0.5),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Text(snapshot.data.documents[index]["description"],textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Dubai'),)
                                          ],
                                        ),
                                      );
                                    }else if(snapshot.data.documents[index]["description_eng"] != null){
                                      return Container(
                                        alignment: Alignment.center,
                                        //height: 30,
                                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.width*0.2,maxWidth: MediaQuery.of(context).size.width*0.5),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Text(snapshot.data.documents[index]["description_eng"],textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Dubai'),)
                                          ],
                                        ),
                                      );
                                    }else return Container(
                                      alignment: Alignment.center,
                                      //height: 30,
                                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.width*0.2,maxWidth: MediaQuery.of(context).size.width*0.5),
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Text(snapshot.data.documents[index]["description"],textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Dubai'),)
                                        ],
                                      ),
                                    );
                                  }),
                                  Container(
                                    alignment: Alignment.center,
                                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.width*0.1),
                                    child: Text(snapshot.data.documents[index]["price"].toString() +"\t" + DemoLocalizations.of(context)
                                        .gettranslatedValue('Home_page_50'),style: TextStyle(fontFamily: 'Dubai'),),
                                  ),
                                  int.parse(snapshot.data.documents[index]["quantity"]) == 0 ?
                                  Container(
                                      child: Text(DemoLocalizations.of(context)
                                          .gettranslatedValue('Home_page_336'),style: TextStyle(fontFamily: 'Dubai'),)):
                                  Container(
                                    alignment: Alignment.center,
                                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.width*0.1),
                                    child: FlatButton.icon(onPressed: (){
                                      Firestore.instance
                                          .collection("web_cart")
                                          .document(_userId)
                                          .collection("items")
                                          .getDocuments()
                                          .then((snapShot) async {
                                        String docId = await Firestore.instance
                                            .collection("web_cart")
                                            .document()
                                            .documentID;
                                        Firestore.instance
                                            .collection("web_cart")
                                            .document(_userId)
                                            .collection("items")
                                            .document(docId)
                                            .setData({
                                          "name": snapshot.data.documents[index]["name"],
                                          "description": snapshot.data.documents[index]["description"],
                                          "price": snapshot.data.documents[index]["price"],
                                          "picture":snapshot.data.documents[index]["picture"],
                                          "quantity": 1,
                                          "ownerId": "ytl0Jl0GXJe5Buults4xAM3pHB42",
                                          "total_quantity": snapshot.data.documents[index]["quantity"],
                                          "size": snapshot.data.documents[index]["size"],
                                          "product_id": snapshot.data.documents[index]["key"],
                                          "id": docId,
                                          "special_request": "Ronza Massage Text: "+ronza_text.text.toString()+" Ronza selected Text: "+selected_text + " Ronza Selected stamp color: "+selected_color + " Departue Selected: " +departur+" Departure Name on Perfume: " +name_on.text.toString()+" Departure three Names: " +three_name.text.toString()+" Departure date of birth: " +date_of_birthdd.text.toString()+"/"+date_of_birthmm.text.toString()+"/"+date_of_birthyy.text.toString()+" Departure place on birth: " +place_of_birth.text.toString()+" Departure travel to: " +travel_to.text.toString(),
                                        }).whenComplete(() {
                                          Firestore.instance
                                              .collection("web_cart")
                                              .document(_userId)
                                              .get()
                                              .then((doc) {
                                            if (doc.data != null) {
                                              double newPrice = doc["totalPrice"] +
                                                  double.parse(snapshot.data.documents[index]["price"]);
                                              Firestore.instance
                                                  .collection("web_cart")
                                                  .document(_userId)
                                                  .updateData({"totalPrice": newPrice});
                                            }
                                            else {
                                              double newPrice =
                                              double.parse(snapshot.data.documents[index]["price"]);
                                              Firestore.instance
                                                  .collection("web_cart")
                                                  .document(_userId)
                                                  .setData({"totalPrice": newPrice});
                                            }
                                          });
                                        });


                                      });
                                    }, icon: Icon(Icons.card_travel_outlined), label: Text(DemoLocalizations.of(context)
                                        .gettranslatedValue('Home_page_195'))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(thickness: 2,color: Colors.blue.withOpacity(0.2),),

                        ],
                      );
                    });
              }),
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                child: Text(" Designed and Created By ",style: TextStyle(fontFamily: 'Dubai'),),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                child: Text("Atyaab",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Dubai'),),
              ),
            ],
          ),
          /*
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.center,
            child: Text("Designed and Created By Atyaab"),
          ),

           */
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(

                  onTap: (){},
                  child: Image.asset("images/down_android.png",width: MediaQuery.of(context).size.width*0.28,height: MediaQuery.of(context).size.width*0.07,fit: BoxFit.fill,),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child:  InkWell(
                  onTap: (){},
                  child: Image.asset("images/down_apple.png",width: MediaQuery.of(context).size.width*0.28,height: MediaQuery.of(context).size.width*0.07,fit: BoxFit.fill),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),

      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          const url ="https://api.WhatsApp.com/send?phone=971556622636";
          if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw "Could not launch $url";
    }
        },
        child: Icon(FontAwesomeIcons.whatsapp,),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
       */
    );
  }
}