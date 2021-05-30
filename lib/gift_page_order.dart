import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:departure/utils/static_members.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:random_string/random_string.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:departure/localization/demo_localization.dart';


import 'HomePage.dart';

class GiftPage extends StatefulWidget {
  double totalPrice;
  final List<Map<String, dynamic>> products;
  final double price_after_discount;
  final String dicount_check;
  final String saved_text;
  final String discount_key;
  final String special_request;
  GiftPage(
      {this.totalPrice,
        this.products,
        this.price_after_discount,
        this.dicount_check,
        this.saved_text,
        this.discount_key,
        this.special_request

      });

  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  var location_reciver = TextEditingController();
  var _reciver_name = TextEditingController();
  var _letter_body = TextEditingController();
  var _sender_name = TextEditingController();
  var _notes = TextEditingController();

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showLoader = false;
  //static const LatLng _latLng = const LatLng(24.382469, 54.640647);
  bool isChecked = false;
  bool isChecked_diliv1 = false,isChecked_diliv2 = false,isChecked_diliv3 = false,only_perfume = false,selectperfume=false;
  String apiKey;
  List getsizelist = [];
  List quantity_list = [];
  List namekeylist = [];
  String orderId = "";
  String orderId_discount = "";

  void APIkey() {
    if (Platform.isAndroid) {
      apiKey = "AIzaSyBa9gATZ0Ehrb4JUwcpIwf1zOmBie_oWq4";
    } else {
      apiKey = "AIzaSyC9FYDwGQHh5GXh_uEadKPnHO693WA6sY0";
    }
  }

  bool isInProgress = false;
  String countrystart = "+971", phoneNo = "", phone,phone_reciver = "",Gift_selection = '';
  var number = TextEditingController();
  var reciver_number = TextEditingController();

  String Selected_number = "050",Selected_number_reciver = "050";
  List<DropdownMenuItem<String>> list_two_numbers = [];
  List<DropdownMenuItem<String>> list_two_numbers_reciver = [];

  void loads_number() {
    list_two_numbers = [];
    list_two_numbers.add(DropdownMenuItem(child: new Text("050"), value: '050'));
    list_two_numbers.add(DropdownMenuItem(child: new Text("052"), value: '052'));
    list_two_numbers.add(DropdownMenuItem(child: new Text("054",), value: '054'));
    list_two_numbers.add(DropdownMenuItem(child: new Text("055"), value: '055'));
    list_two_numbers.add(DropdownMenuItem(child: new Text("056"), value: '056'));
    list_two_numbers.add(DropdownMenuItem(child: new Text("058"), value: '058'));
  }

  void loads_number_reciver() {
    list_two_numbers_reciver = [];
    list_two_numbers_reciver.add(DropdownMenuItem(child: new Text("050"), value: '050'));
    list_two_numbers_reciver.add(DropdownMenuItem(child: new Text("052"), value: '052'));
    list_two_numbers_reciver.add(DropdownMenuItem(child: new Text("054",), value: '054'));
    list_two_numbers_reciver.add(DropdownMenuItem(child: new Text("055"), value: '055'));
    list_two_numbers_reciver.add(DropdownMenuItem(child: new Text("056"), value: '056'));
    list_two_numbers_reciver.add(DropdownMenuItem(child: new Text("058"), value: '058'));
  }

  static show_order_created_dialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            content: Container(
              width: 200,
              height: 220,
              child: Center(
                child: ListTile(
                  title: Text(
                    "Your order has been successfully completed. You can track your order on My Orders page.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 19, fontFamily: 'Dubai'),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Image.asset(
                      'images/tenor.gif',
                      width: 75,
                      height: 75,
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: MaterialButton(
                      color: Colors.black,
                      child: Text(
                        "Close",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Dubai'),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                                (Route<dynamic> route) => false);
                      },
                    ),
                  )
                ],
              )
            ],
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
  String selectedLoc = "اختيار الموقع Select Location";
  String selectedDate = "Delivery Date";
  String selectedDatearabic = "يوم التوصيل";

  String selectedTime = "Preferred Time";
  String selectedTimearabic = "الوقت المفضل";

  DateTime selected;
  String dicount_check = "null";
  Show_rules(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  Flexible(
                    child: new Text(
                      "RETURN POLICY \n "
                          "Conditions Applicable to Returns \n "
                          "Subject to meeting the conditions set out in this Returns section, we offer a (no questions asked) free-returns policy which allows you to return delivered items to us for any reason up to 1 day (24 hours) after the receiving your Order. \n"
                          " In order to qualify for a refund, all items must be returned to us within 1 day of Order receipt with the following conditions: \n"
                          " Items must be unaltered, unused and in full sellable condition (or the condition in which they were received from us or our agents). Perfumes must be in brand-new condition and without any damage. \n "
                          "Items must be in their original packaging and with all brand and product labels still attached. \n The return must be accompanied by the original Order confirmation. \n"
                          " Returns Process \n "
                          "Items can be returned by arranging collection from your delivery address in the UAE by following the steps below: \n "
                          "Refund Process \n"
                          " Refunds will only be processed after completing the Return Process and the item/s returned have been approved. After approval, we will issue a refund of the full face value of undamaged items duly returned (excluding, where applicable, the original delivery charges and cash-handling fees). \n"
                          " Your refund will be processed via the following method, Cash on Delivery payments are refunded as Bank Transfer. \n "
                          "Item Return Policies \n "
                          "Damaged Goods and Incorrectly-Fulfilled Orders \n "
                          "If you receive an item that is damaged or not the product you ordered, please arrange for the return of the item to us using the Returns Process above. The item must be returned in the same condition you received it within 1 day (24 hours) of receipt to qualify for a full refund. Where applicable, the refund will include only the price of the product and will exclude the delivery or the taxes charges. If you believe your item is defective, please call us on +971554457681. \n "
                          "Packaging \n "
                          "Please take care to preserve the condition of any product packaging as, for example, damaged perfumes boxes may prevent re-sale and may mean that we cannot give you a refund. Our agents may ask to inspect returned items at the point of collection but that initial inspection does not constitute a guarantee of your eligibility for a full refund.",
                      style:
                      TextStyle(color: Colors.black, fontFamily: 'Dubai'),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Flexible(
                    child: new Text(
                      "ONLINE PRIVACY POLICY AGREEMENT \n "
                          "Atyaab values its users' privacy. This Privacy Policy (Policy) will help you understand how we collect and use personal information from those who visit our website or make use of our online facilities and services, and what we will and will not do with the information we collect. Our Policy has been designed and created to ensure those affiliated with Atyaab of our commitment and realization of our obligation not only to meet but to exceed most existing privacy standards.\n "
                          "We reserve the right to make changes to this Policy at any given time. If you want to make sure that you are up to date with the latest changes, we advise you to frequently visit this page. If at any point in time Atyaab decides to make use of any personally identifiable information on file, in a manner vastly different from that which was stated when this information was initially collected, the user or users shall be promptly notified by email. Users at that time shall have the option as to whether to permit the use of their information in this separate manner.\n"
                          "This Policy applies to Atyaab, and it governs any and all data collection and usage by us. Through the use of www.atyaab.ae or Atyaab application, you are therefore consenting to the data collection procedures expressed in this Policy.\n"
                          "Please note that this Policy does not govern the collection and use of information by companies that Atyaab does not control, nor by individuals not employed or managed by us. If you visit a website that we mention or link to, be sure to review its privacy policy before providing the site with information. It is highly recommended and suggested that you review the privacy policies and statements of any website you choose to use or frequent to better understand the way in which websites garner, make use of and share the information collected.\n "
                          "Information We Collect \n"
                          "It is always up to you whether to disclose personally identifiable information to us, although if you elect not to do so, we reserve the right not to register you as a user or provide you with any products or services. This website collects various types of information, such as: \n "
                          "Voluntarily provided information which may include your name, address, phone number, billing and/or credit card information, etc. Which may be used when you purchase products and/or services and to deliver the services you have requested.\n "
                          "Information automatically collected when visiting our website, which may include cookies, third party tracking technologies and server logs. \n"
                          "In addition,  may have the occasion to collect non-personal anonymous demographic information, such as age, gender, household income, political affiliation, race and religion, as well as the type of browser you are using, IP address, or type of operating system, which will assist us in providing and maintaining superior quality service. \n"
                          "Atyaab may also deem it necessary, from time to time, to follow websites that our users may frequent to gleam what types of services and products may be the most popular to customers or the general public.\n "
                          "Please rest assured that this site will only collect personal information that you knowingly and willingly provide to us by way of surveys, completed membership forms, and emails. It is the intent of this site to use personal information only for the purpose for which it was requested, and any additional uses specifically provided for in this Policy.\n "
                          "Why We Collect Information and For How Long \n "
                          "We are collecting your data for several reasons: \n"
                          "To better understand your needs and provide you with the services you have requested;\n "
                          "To fulfill our legitimate interest in improving our services and products; \n"
                          "To send you promotional emails containing information we think you may like when we have your consent to do so; \n"
                          "To contact you to fill out surveys or participate in other types of market research, when we have your consent to do so;\n"
                          "To customize our website according to your online behavior and personal preferences.\n"
                          "The data we collect from you will be stored for no longer than necessary. The length of time we retain said information will be determined based upon the following criteria: the length of time your personal information remains relevant; the length of time it is reasonable to keep records to demonstrate that we have fulfilled our duties and obligations; any limitation periods within which claims might be made; any retention periods prescribed by law or recommended by regulators, professional bodies or associations; the type of contract we have with you, the existence of your consent, and our legitimate interest in keeping such information as stated in this Policy.\n"
                          "Use of Information Collected\n"
                          "Atyaab does not now, nor will it in the future, sell, rent or lease any of its customer lists and/or names to any third parties.\n"
                          "Atyaab may collect and may make use of personal information to assist in the operation of our website and to ensure delivery of the services you need and request. At times, we may find it necessary to use personally identifiable information as a means to keep you informed of other possible products and/or services that may be available to you from Atyaab\n"
                          "Atyaab may also be in contact with you with regards to completing surveys and/or research questionnaires related to your opinion of current or potential future services that may be offered.\n"
                          "Atyaab may find it beneficial to all our customers to share specific data with our trusted partners in an effort to conduct statistical analysis, provide you with email and/or postal mail, deliver support and/or arrange for deliveries to be made. Those third parties shall be strictly prohibited from making use of your personal information, other than to deliver those services which you requested, and as such they are required, in accordance with this agreement, to maintain the strictest of confidentiality with regards to all your information.\n"
                          "Atyaab uses various third-party social media features including but not limited to Snapchat, Instagram and other interactive programs.  These may collect your IP address and require cookies to work properly.  These services are governed by the privacy policies of the providers and are not within Atyaab’s control.\n"
                          "Disclosure of Information\n"
                          "Atyaab may not use or disclose the information provided by you except under the following circumstances:\n"
                          "as necessary to provide services or products you have ordered;\n"
                          "in other ways described in this Policy or to which you have otherwise consented;\n"
                          "in the aggregate with other information in such a way so that your identity cannot reasonably be determined;\n"
                          "as required by law, or in response to a subpoena or search warrant;\n"
                          "to outside auditors who have agreed to keep the information confidential;\n"
                          "as necessary to enforce the Terms of Service;\n"
                          "as necessary to maintain, safeguard and preserve all the rights and property of Atyaab.\n"
                          "Non-Marketing Purposes \n"
                          "Atyaab greatly respects your privacy. We do maintain and reserve the right to contact you if needed for non-marketing purposes (such as bug alerts, security breaches, account issues, and/or changes in Atyaab products and services).  In certain circumstances, we may use our website, newspapers, or other public means to post a notice. \n"
                          " Children under the age of 13 \n "
                          "Atyaab website is not directed to and does not knowingly collect personally identifiable information from, children under the age of thirteen (13). If it is determined that such information has been inadvertently collected on anyone under the age of thirteen (13), we shall immediately take the necessary steps to ensure that such information is deleted from our system's database, or in the alternative, that verifiable parental consent is obtained for the use and storage of such information. Anyone under the age of thirteen (13) must seek and obtain parent or guardian permission to use this website. \n"
                          " Unsubscribe or Opt-Out \n"
                          " All users and visitors to our website have the option to discontinue receiving communications from us by way of email or newsletters. To discontinue or unsubscribe from our website please send an email that you wish to unsubscribe to info.atyaab@gmail.com. If you wish to unsubscribe or opt-out from any third-party websites, you must go to that specific website to unsubscribe or opt-out. Atyaab will continue to adhere to this Policy with respect to any personal information previously collected. \n "
                          "Links to Other Websites \n "
                          "Our website does contain links to affiliates and other websites. Atyaab does not claim nor accept responsibility for any privacy policies, practices and/or procedures of other such websites. Therefore, we encourage all users and visitors to be aware when they leave our website and to read the privacy statements of every website that collects personally identifiable information. This Privacy Policy Agreement applies only and solely to the information collected by our website. \n "
                          "Notice to European Union Users \n "
                          "Atyaab's operations are located primarily in the United Arab Emirates. If you provide information to us, the information will be transferred out of the European Union (EU) and sent to the United Arab Emirates. (The adequacy decision on the EU-US Privacy became operational on August 1, 2016. This framework protects the fundamental rights of anyone in the EU whose personal data is transferred to the United Arab Emirates for commercial purposes. It allows the free transfer of data to companies that are certified in the US under the Privacy Shield.) By providing personal information to us, you are consenting to its storage and use as described in this Policy. \n"
                          " Security \n"
                          " Atyaab takes precautions to protect your information. When you submit sensitive information via the website, your information is protected both online and offline. Wherever we collect sensitive information (e.g. credit card information), that information is encrypted and transmitted to us in a secure way. You can verify this by looking for a lock icon in the address bar and looking for https at the beginning of the address of the webpage. \n "
                          "While we use encryption to protect sensitive information transmitted online, we also protect your information offline. Only employees who need the information to perform a specific job (for example, billing or customer service) are granted access to personally identifiable information. The computers and servers in which we store personally identifiable information are kept in a secure environment. This is all done to prevent any loss, misuse, unauthorized access, disclosure or modification of the user's personal information under our control. \n "
                          "Acceptance of Terms \n "
                          "By using this website, you are hereby accepting the terms and conditions stipulated within the Privacy Policy Agreement. If you are not in agreement with our terms and conditions, then you should refrain from further use of our sites. In addition, your continued use of our website following the posting of any updates or changes to our terms and conditions shall mean that you agree and the acceptance of such changes. \n How to Contact Us \n If you have any questions or concerns regarding the Privacy Policy Agreement related to our website, please feel free to contact us at the following email, telephone number or mailing address. \n "
                          "Email: info.atyaab@gmail.com \n"
                          " Telephone Number: +971554457681 \n "
                          "Mailing Address: \n "
                          "Atyaab \n "
                          "Abudhabi Gate, \n "
                          "Abu Dhabi, Abu Dhabi \n "
                          "00971 \n",
                      style:
                      TextStyle(color: Colors.black, fontFamily: 'Dubai'),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.black,
                child: Text(
                  DemoLocalizations.of(context)
                      .gettranslatedValue('Home_page_6'),
                  style: TextStyle(color: Colors.white, fontFamily: 'Dubai'),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  double after_check_code,after_compare,order_with_flower;
  String saved_text,Name_Size;
  List<String> check_name = [];
  List<String> selectedChoices = List();
  String selectedPacks = "";


  String type_of_payment = "Card",Gift_option_selected = "",selectedPerfumeName;
  int selectedPaymentType = 1,selectedPerfume = 0,_value = 0,selectedFlowerPack = 0;
  int selectedGiftType = 0;
  bool isSelected = false;


  setSelectedvaluecondition(int value) {
    setState(() {
      selectedPaymentType = value;
    });
  }
  setselectedGiftType(int value) {
    setState(() {
      selectedGiftType = value;
    });
  }
  setSelectedpack(int value) {
    setState(() {
      selectedPaymentType = value;
    });
  }
  bool in_uae = true,out_uae = false,stop = false,verfied_number = false;

  List<Widget> choices = List();


  Widget _showPlaceOrderPage() {
    loads_number();
    loads_number_reciver();
    return Form(
      key: _formKey,
      child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 7,left:16,right: 16 ),
              child: Text(
                DemoLocalizations.of(context).gettranslatedValue('Home_page_297'),
                style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
              width: MediaQuery.of(context).size.width*0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.5,
                      height: 60,
                      child: TextFormField(
                        maxLength: 7,
                        validator: (value) {
                          if (phoneNo.isEmpty) {
                            return DemoLocalizations.of(context)
                                .gettranslatedValue('Home_page_34');
                          } else if (phoneNo.length < 7) {
                            return DemoLocalizations.of(context)
                                .gettranslatedValue('Home_page_34');
                          } else if (phoneNo.length > 7) {
                            return DemoLocalizations.of(context)
                                .gettranslatedValue('Home_page_34');
                          }
                          return null;
                        },
                        controller: number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black,fontSize: 18,letterSpacing: 4.5
                        ),
                        onChanged: (value) {
                          setState(() {
                            this.phoneNo = value.trim();
                            if (value.length == 7) { //10 is the length of the phone number you're allowing
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5,),
                    child: Container(
                      width: 65,
                      alignment: Alignment.topCenter,
                      child: new Center(
                        child: DropdownButton(
                          value: Selected_number,
                          items: list_two_numbers,
                          elevation: 60,
                          onChanged: (value) {
                            setState(() {
                              Selected_number = value;
                            });
                          },
                          isExpanded: true,
                          iconSize: 30,
                          style: TextStyle(fontSize: 18,color: Colors.black),
                          hint: Text(
                            "050",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16,right: 16,bottom: 5),
              child: Text(
                DemoLocalizations.of(context)
                    .gettranslatedValue('Home_page_298'),
                style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 17,vertical: 5),
              alignment: AlignmentDirectional.topStart,
              height: 350,
              decoration: BoxDecoration(
                boxShadow:[
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 3,
                    blurRadius:0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Colors.black),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                        height: 50,
                        alignment: AlignmentDirectional.topStart,
                        width:  MediaQuery.of(context).size.width*0.68,
                        child: Container(
                          width: 200,
                          child: TextField(
                            //maxLines: 1,
                            controller: _reciver_name,
                            maxLength: 25,
                            style: TextStyle(fontFamily: 'Dubai',fontSize: 18,fontStyle: FontStyle.italic),
                            decoration: InputDecoration(
                              hintText: DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_299'),
                              hintStyle:TextStyle(fontFamily: 'Dubai',fontSize: 16,fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width:  MediaQuery.of(context).size.width*0.15,
                          alignment: AlignmentDirectional.topEnd,
                        child: Align(alignment: Alignment.topRight,
                            child: Image.asset("images/appbartitle.png",width: 50,height: 50,),)
                      ),
                    ],
                  ),
                  Container(
                    height: 150,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: AlignmentDirectional.topStart,
                    child: TextField(
                      controller: _letter_body,
                      maxLines: 4,
                      maxLength: 200,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontFamily: 'Dubai',fontSize: 18,fontStyle: FontStyle.italic),
                      decoration: InputDecoration(
                        hintText: DemoLocalizations.of(context)
                            .gettranslatedValue('Home_page_300'),
                        hintStyle:TextStyle(fontFamily: 'Dubai',fontSize: 16,fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    alignment: AlignmentDirectional.topStart,
                    width:  MediaQuery.of(context).size.width,
                    child: Container(
                      width: 200,
                      child: TextField(
                        controller: _sender_name,
                        maxLength: 25,
                        style: TextStyle(fontFamily: 'Dubai',fontSize: 18,fontStyle: FontStyle.italic),
                        decoration: InputDecoration(
                          hintText: DemoLocalizations.of(context)
                              .gettranslatedValue('Home_page_301'),
                          hintStyle:TextStyle(fontFamily: 'Dubai',fontSize: 16,fontStyle: FontStyle.italic),

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 17,vertical: 5),
              alignment: AlignmentDirectional.topStart,
              height: 90,
              decoration: BoxDecoration(
                boxShadow:[
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 3,
                    blurRadius:0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Colors.black),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                alignment: AlignmentDirectional.topStart,
                width:  MediaQuery.of(context).size.width,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: _notes,
                    maxLength: 100,
                    maxLines: 2,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontFamily: 'Dubai',fontSize: 18,fontStyle: FontStyle.italic),
                    decoration: InputDecoration(
                      hintText: DemoLocalizations.of(context)
                          .gettranslatedValue('Home_page_302'),
                      hintStyle:TextStyle(fontFamily: 'Dubai',fontSize: 16,fontStyle: FontStyle.italic),

                    ),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
              child: Text(
                DemoLocalizations.of(context)
                    .gettranslatedValue('Home_page_306'),
                style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("flowers_pack").orderBy("price",descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                      height: 305,
                      width: double.infinity,
                      child: Scrollbar(
                        radius: Radius.circular(20),
                        thickness: 10,
                        isAlwaysShown: true,
                        child:  ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return flower_pack(
                                  index,
                                  snapshot.data.documents[index].data["image"],
                                  snapshot.data.documents[index].data["price"],
                                  snapshot.data.documents[index].data["pack_id"],
                                  snapshot.data.documents[index].data["number_perfumes"]);
                            }),
                      )
                  );

                }),
            InkWell(
              onTap: (){
                Gift_option_selected = "Option 1";
                setselectedGiftType(1);
                selectedPacks = "";
                order_with_flower = widget.totalPrice;

              },
              child: Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 7,bottom: 5),
                width: MediaQuery.of(context).size.width*0.4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 4.0,
                      spreadRadius: 1.0,
                      offset: Offset(0.0, 0.0),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: selectedGiftType,
                      activeColor: Colors.green,
                      onChanged: (val) {
                        setselectedGiftType(val);
                        Gift_option_selected = "Option 1";
                        selectedPacks = "";
                        order_with_flower = widget.totalPrice;


                      },
                    ),
                    Text(
                      DemoLocalizations.of(context)
                          .gettranslatedValue('Home_page_309'),
                      style: TextStyle(fontSize: 14, fontFamily: 'Dubai',color: Gift_option_selected == "Option 1"?Colors.green:Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Builder(
              builder: (cotext){
                check_name.clear();
                return Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: ListView.builder(
                      itemCount: widget.products.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        return product_name(index);
                      }
                  ),
                );
              },
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                DemoLocalizations.of(context)
                    .gettranslatedValue('Home_page_303'),
                style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
              ),
            ),
            Builder(builder: (context){
              if(Gift_option_selected != '' || only_perfume || selectedPacks != ""){
                return Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: MediaQuery.of(context).size.width*0.5,
                        height: 60,
                        child: TextFormField(
                          maxLength: 7,
                          validator: (value) {
                            if (phone_reciver.isEmpty) {
                              return DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_34');
                            } else if (phone_reciver.length < 7) {
                              return DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_34');
                            } else if (phone_reciver.length > 7) {
                              return DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_34');
                            }
                            return null;
                          },
                          controller: reciver_number,
                          textInputAction: TextInputAction.done,

                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.black,fontSize: 18,letterSpacing: 4.5),
                          onChanged: (value) {
                            setState(() {
                              this.phone_reciver = value.trim();
                              if (value.length == 7) { //10 is the length of the phone number you're allowing
                                FocusScope.of(context).requestFocus(FocusNode());
                              }

                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                        width: 65,
                        child: Center(
                          child: DropdownButton(
                            value: Selected_number_reciver,
                            items: list_two_numbers_reciver,
                            elevation: 60,
                            onChanged: (value) {
                              setState(() {
                                Selected_number_reciver = value;
                              });
                            },
                            isExpanded: true,
                            iconSize: 30,
                            style: TextStyle(fontSize: 18,color: Colors.black),
                            hint: Text(
                              "050",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              else return Container();
            }),
            SizedBox(
              height: 8,
            ),
            Builder(builder: (context){
              if(Gift_option_selected != '' || only_perfume || selectedPacks != ""){
                return Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: TextField(
                    controller: location_reciver,
                    style: TextStyle(fontFamily: 'Dubai'),
                    decoration: InputDecoration(
                      hintText: DemoLocalizations.of(context)
                          .gettranslatedValue('Home_page_304'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }else return Container();

            }),
            SizedBox(
              height: 13,
            ),
            Builder(builder: (context){
              if(Gift_option_selected != '' || selectedPacks != ""){
                return InkWell(
                  onTap: () async {
                    DateTime firt_date;
                    DateTime initial_Date;
                    if(DateTime.now().weekday == 3){
                      firt_date = DateTime.now().add(Duration(days:3));
                      initial_Date = DateTime.now().add(Duration(days: 3));
                    }
                    else {
                      firt_date = DateTime.now().add(Duration(days: 2));
                      initial_Date = DateTime.now().add(Duration(days: 2));
                    }
                    DateTime now = DateTime.now();
                    selected = await showDatePicker(
                        context: context,
                        initialDate: initial_Date,
                        firstDate: firt_date,
                        lastDate: DateTime(now.year, now.month + 2),
                        selectableDayPredicate: (dt) {
                          if(dt.weekday == 5){
                            return false;
                          }
                          return true;
                        });
                    setState(() {
                      selectedDate =
                      "${selected.day}/${selected.month}/${selected.year}";
                      selectedDatearabic = "";
                    });
                  },
                  child:  Container(
                      constraints: BoxConstraints(minHeight: 60),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 0.0),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.body1,
                          children: [
                            TextSpan(text: selectedDate == "Delivery Date"?DemoLocalizations.of(context).gettranslatedValue('Home_page_3022')+"\t": selectedDate,style: TextStyle(color: Colors.black, fontFamily: 'Dubai',fontSize: 18,),),
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Icon(Icons.date_range_rounded,size: 28,),
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                );
              }else return Container();

            }),
            SizedBox(
              height: 4,
            ),
            Divider(
              thickness: 2,
            ),
            Builder(
              builder: (context) {
                if (phone_reciver.length == 7) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      DemoLocalizations.of(context)
                          .gettranslatedValue('Home_page_257'),
                      style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                else return Container();
              },
            ),
            SizedBox(
              height: 8,
            ),
            Builder(
              builder: (context) {
                  return Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: RaisedButton(
                      color:(phone_reciver.length == 7) ? Colors.black : Colors.black26,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () async {
                        if(phone_reciver.length == 7){
                          String random6 = randomAlphaNumeric(6);
                          namekeylist.clear();
                          double total_price = order_with_flower;
                          setState(() {
                            _showLoader = true;
                          });
                          var data;
                          if (widget.dicount_check == "true") {
                            data = {
                              "totalPrice": total_price,
                              "sender_phone": "+971" + Selected_number + phoneNo,
                              "receiver_name": _reciver_name.text.trim(),
                              "_letter_body": _letter_body.text.trim(),
                              "_sender_name": _sender_name.text.trim(),
                              "_notes": _notes.text.trim(),
                              "Gift_selection": Gift_selection,
                              "Gift_option_selected": Gift_option_selected,
                              "selectedChoices":selectedChoices,
                              "receiver_phone":Selected_number_reciver + phone_reciver,
                              "location": location_reciver.text,
                              "delivery_date": selected,
                              "products": widget.products,
                              "payment_method": type_of_payment,
                              "order_state": "order_in_progress",
                              "order_id_customer": random6,
                              "Date_of_order": DateTime.now(),
                              "price_after_discount": widget.price_after_discount,
                              "saved_text": widget.saved_text,
                              "location_name":"Gift",
                              "order_state": "order_in_progress",
                            };
                          }
                          else {
                            data = {
                              "totalPrice": total_price,
                              "sender_phone": "+971" + Selected_number + phoneNo,
                              "receiver_name": _reciver_name.text.trim(),
                              "letter body": _letter_body.text.trim(),
                              "_sender_name": _sender_name.text.trim(),
                              "_notes": _notes.text.trim(),
                              "Gift_selection": Gift_selection,
                              "Gift_option_selected": Gift_option_selected,
                              "selectedChoices":selectedChoices,
                              "receiver_phone":Selected_number_reciver + phone_reciver,
                              "location": location_reciver.text,
                              "delivery_date": selected,
                              "products": widget.products,
                              "payment_method": type_of_payment,
                              "order_state": "order_in_progress",
                              "order_id_customer": random6,
                              "Date_of_order": DateTime.now(),
                              "location_name":"Gift",
                              "order_state": "order_in_progress",
                            };
                          }

                          await Firestore.instance
                              .collection("orders")
                              .add(data)
                              .then((value) async {
                            namekeylist.clear();
                            orderId = value.documentID;
                            Firestore.instance
                                .collection("orders")
                                .document(value.documentID)
                                .updateData({
                              "order_id": value.documentID,
                            });

                            if (widget.dicount_check == "true") {
                              await Firestore.instance
                                  .collection("discount_code")
                                  .snapshots()
                                  .listen((event_out) async {
                                for (int i = 0; i < event_out.documents.length; i++) {
                                  if (widget.saved_text ==
                                      event_out.documents[i]['code'] &&
                                      stop == false) {
                                    await Firestore.instance
                                        .collection("discount_code")
                                        .document(widget.discount_key)
                                        .collection("discount_customer")
                                        .add({
                                      "customer_order_id": random6,
                                      "price_after_discount":
                                      widget.price_after_discount,
                                      "totalPrice": total_price,
                                      "products": widget.products,
                                      "delivery_date": selected,
                                    }).then((value) async {
                                      orderId_discount = value.documentID;
                                      await Firestore.instance
                                          .collection("discount_code")
                                          .document(widget.discount_key)
                                          .collection("discount_customer")
                                          .document(value.documentID)
                                          .updateData({
                                        "order_id": value.documentID,
                                      });

                                      var document = await Firestore.instance
                                          .collection("discount_code")
                                          .document(widget.discount_key);
                                      document.get().then((document) {
                                        int number_decrease =
                                            document.data["number_of_use"] - 1;
                                        Firestore.instance
                                            .collection("discount_code")
                                            .document(widget.discount_key)
                                            .updateData({
                                          "number_of_use": number_decrease,
                                        });
                                      });
                                    });

                                    stop = true;
                                  }
                                }
                              });
                            }

                            widget.products.forEach((product) async {
                              await Firestore.instance
                                  .collection("stores")
                                  .document(product["ownerId"])
                                  .collection("products")
                                  .document(product["itemId"])
                                  .get()
                                  .then((currentProd) async {
                                String namekey =
                                    product["itemName"] + product["itemSize"];
                                if (!namekeylist.contains(namekey)) {
                                  namekeylist.add(namekey);
                                  getsizelist.clear();
                                  getsizelist = currentProd['size'].split(",");
                                  int index_of_size =
                                  getsizelist.indexOf(product["itemSize"]);
                                  quantity_list = currentProd['quantity'].split(",");

                                  String new_quantity =
                                  (int.parse(quantity_list[index_of_size]) -
                                      int.parse(
                                          product["itemQuantity"].toString()))
                                      .toString();
                                  quantity_list[index_of_size] = new_quantity;
                                  String quantity_list_string =
                                  quantity_list.join(",");
                                  int num_of_selling;
                                  await Firestore.instance
                                      .collection("stores")
                                      .document(product["ownerId"])
                                      .collection("products")
                                      .document(product["itemId"])
                                      .get()
                                      .then((value) {
                                    num_of_selling = value.data['num_of_selling'];
                                  });

                                  await Firestore.instance
                                      .collection("stores")
                                      .document(product["ownerId"])
                                      .collection("products")
                                      .document(product["itemId"])
                                      .updateData({
                                    "quantity": quantity_list_string,
                                    "num_of_selling":
                                    num_of_selling + product["itemQuantity"]
                                  });
                                }
                              });
                            });
                          });
                          if (type_of_payment == "Card") {
                            await makeOnlinePayment(
                                context, orderId, total_price.toString());
                            return false;
                          } else {
                            show_order_created_dialog(context);
                            sendNofication(orderId);
                          }
                        }
                      },
                      child: _showLoader
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                        DemoLocalizations.of(context)
                            .gettranslatedValue('Home_page_48'),
                        style: TextStyle(fontFamily: 'Dubai'),
                      ),
                      textColor: Colors.white,
                    ),
                  );
              },
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16,),
              child: Text(DemoLocalizations.of(context).gettranslatedValue('Home_page_314'), style: TextStyle(fontFamily: 'Dubai'),),
            ),
            FlatButton(
                onPressed: () {
                  Show_rules(context);
                },
                child: Text(
                  DemoLocalizations.of(context).gettranslatedValue('Home_page_237'),
                  style: TextStyle(fontFamily: 'Dubai'),
                ))
          ]),
    );
  }

  Widget product_name(index){
      Name_Size = widget.products[index]["itemName"]+widget.products[index]["itemSize"].toString();
      if(!check_name.contains(Name_Size)){
        check_name.add(Name_Size);
        return Card(
          color: Colors.transparent,
          shadowColor:Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ChoiceChip(
                selectedColor:Colors.green,
                label: Text(widget.products[index]["itemName"]),
                selected: selectedChoices.contains(widget.products[index]["itemName"]),
                onSelected: (selected) {
                  setState(() {
                    selectedChoices.contains(widget.products[index]["itemName"])
                        ? selectedChoices.remove(widget.products[index]["itemName"])
                        : selectedChoices.add(widget.products[index]["itemName"]);
                  });
                },
              ),
            ],
          ),
        );
      }else return Container();
  }
  Widget flower_pack(index,image,price,pack_id,number_of_perfumes){
    return InkWell(
        child: Card(
          child: Scrollbar(
            isAlwaysShown: true,
            child: Column(
              children: [
                Image.network(image,width: 250,height: 250,fit: BoxFit.fill,),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Icon(Icons.check_circle_rounded,color: selectedPacks == pack_id?Colors.green:Colors.grey,size: 26,),
                        margin: EdgeInsets.symmetric(horizontal: 13),
                      ),
                      Column(
                        children: [
                          Container(
                            child:  Text(
                              price.toString() + " "+DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_50')+" "+ DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_312') +" $number_of_perfumes " + DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_3122'),
                              style: TextStyle(color:selectedPacks == pack_id?Colors.green:Colors.black,fontFamily: 'Dubai'),
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
              ],
            ),
          )
        ),
        onTap: (){
          setState(() {
            selectedPacks = pack_id;
            Gift_option_selected = pack_id;
            setselectedGiftType(0);
            order_with_flower = widget.totalPrice + price;
          });
        },
      );
  }
  getColor() {
    return Colors.blueAccent;
  }

  iconColor() {
    return Colors.grey[850];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: iconColor()),
        title: Text(
          DemoLocalizations.of(context).gettranslatedValue('Home_page_49'),
          style: TextStyle(color: iconColor(), fontFamily: 'Dubai'),
        ),
        elevation: 10,
        backgroundColor: getColor(),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/test22.jpg"), fit: BoxFit.cover)),
        child: _showPlaceOrderPage(),
      ),
    );
  }
}

class Product {
  String name;
  String total;
  String quantity;
  Product(this.name, this.total, this.quantity);
}

sendNofication(String orderId) async {
  Map<String, List<Product>> owners = new Map<String, List<Product>>();
  await Firestore.instance
      .collection("orders")
      .document(orderId)
      .get()
      .then((orderData) async {
    if (orderData.data != null) {
      if (orderData.data['products'] != null &&
          orderData.data['products'].length > 0) {
        for (var i = 0; i < orderData.data['products'].length; i++) {
          String oid = orderData.data['products'][i]['ownerId'];
          Product prod = new Product(
              orderData.data['products'][i]['itemName'],
              orderData.data['products'][i]['itemPrice'].toString(),
              orderData.data['products'][i]['itemQuantity'].toString());
          if (oid != null && oid != "") {
            if (!owners.containsKey(oid)) {
              owners.putIfAbsent(oid, () => List<Product>());
            }
            owners[oid].add(prod);
          }
        }
      }
    }

    await Firestore.instance
        .collection("shop_users")
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents != null) {
        snapshot.documents.forEach((element) async {
          await Firestore.instance
              .collection("shop_users")
              .document(element.documentID)
              .collection("tokens")
              .getDocuments()
              .then((snpshot) {
            if (snpshot.documents != null) {
              snpshot.documents.forEach((ele) async {
                Map<String, dynamic> tokenData = ele.data;
                if (owners.containsKey(tokenData['shopOwnerId'])) {
                  if (tokenData['active'] != null &&
                      tokenData['active'] == true) {
                    String notificationText =
                        "An order is created on your products";
                    owners[tokenData['shopOwnerId']].forEach((item) {
                      notificationText +=
                          item.name + "[AED " + item.total + "]";
                    });
                    await _makePostRequest(
                        tokenData['token'], notificationText);
                  }
                }
              });
            }
          });
        });
      }
    });
  });
}

Future<Response> _makePostRequest(String token, String text) async {
  Uri url = Uri.http("fcm.googleapis.com", "/fcm/send");
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization":
    "key=AAAAyswfKiw:APA91bE0q-i7pqNVYc6tkHRP1kc1ERj568BenrZLCmxvqmduZBfoPXUjiqUCT1T8VD5l4pjqj9snXkj-NbS1Kpy80uLVhQUOZ2ltaXrH6yjTS6aosuNYm-DcTC9_as5hhJIx8tiKDRn4"
  };
  String json = '{"notification": {"body": "' +
      text +
      '", "title": "You have a new sale"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to": "' +
      token +
      '"}';
  Response response = await post(url, headers: headers, body: json);
  return response;
}
//telr
void makeOnlinePayment(
    BuildContext context, String orderID, String amount) async {
  http.Response resp = await getServiceURL(orderID, amount);
  if (resp.statusCode == 200) {
    var data = json.decode(resp.body);
    if (data["err"] != null) {
      print(data["err"]);
    } else if (data["url"] != null) {
      final url = data["url"];
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => MyWebView(
            title: DemoLocalizations.of(context)
                .gettranslatedValue('Home_page_270'),
            selectedUrl: url,
            orderID: orderID,
          )));
    } else {
      print("Some Error");
    }
  } else {
    print('Some Error Occurred. Please try again.');
  }
}

Future<http.Response> getServiceURL(String cartID, String amount) async {
  return http.post(
    Uri.http("atyaab.ae", "/payment/payment.php"),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{"order": cartID, "amount": amount}),
  );
}

class MyWebView extends StatefulWidget {
  final String title;
  final String selectedUrl;
  final String orderID;
  const MyWebView({this.title, this.selectedUrl, this.orderID});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  InAppWebViewController _controller;
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(fontFamily: 'Dubai')),
          leading: new Container(),
        ),
        body: Container(
            child:
            InAppWebView(
              initialUrl: widget.selectedUrl,
              initialHeaders: {},
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                  )),
              onWebViewCreated: (InAppWebViewController controller) {
                _controller = controller;
              },
              onUpdateVisitedHistory: (InAppWebViewController controller,
                  String url, bool androidIsReload) {
                switch (url) {
                  case "http://atyaab.ae/payment/auth.php":
                    {
                      Firestore.instance
                          .collection("orders")
                          .document(widget.orderID)
                          .updateData({"status": "success"});

                      Firestore.instance
                          .collection("cart")
                          .document(StaticMembers.userId)
                          .collection("items")
                          .getDocuments()
                          .then((snapshot) {
                        snapshot.documents.forEach((doc) {
                          doc.reference.delete();
                        });
                      });

                      sendNofication(widget.orderID);

                      String text = DemoLocalizations.of(context)
                          .gettranslatedValue('Home_page_262') +
                          widget.orderID;
                      _showAlert(context, text);
                    }
                    break;
                  case "http://atyaab.ae/payment/cancel.php":
                    {
                      Firestore.instance
                          .collection("orders")
                          .document(widget.orderID)
                          .updateData({"status": "cancelled"});

                      String text = DemoLocalizations.of(context)
                          .gettranslatedValue('Home_page_263') +
                          widget.orderID;
                      _showAlert(context, text);
                    }
                    break;
                  case "http://atyaab.ae/payment/decline.php":
                    {
                      Firestore.instance
                          .collection("orders")
                          .document(widget.orderID)
                          .updateData({"status": "declined"});

                      String text = DemoLocalizations.of(context)
                          .gettranslatedValue('Home_page_264') +
                          widget.orderID +
                          DemoLocalizations.of(context)
                              .gettranslatedValue('Home_page_265');
                      _showAlert(context, text);
                    }
                    break;
                  default:
                    {}
                    break;
                }
                setState(() {
                  this.url = url;
                });
              },
              onLoadStart: (InAppWebViewController controller, String url) {
                setState(() {
                  this.url = url;
                });
              },
              onLoadStop: (InAppWebViewController controller, String url) async {
                setState(() {
                  this.url = url;
                });
              },
            )
        ));
  }

  void _showAlert(BuildContext context, String text) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.all(15.0),
          title: Text(DemoLocalizations.of(context)
              .gettranslatedValue('Home_page_261')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text, style: TextStyle(fontFamily: 'Dubai')),
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
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => MyHomePage()),
                          (Route<dynamic> route) => false);
                },
                child: Text(
                  DemoLocalizations.of(context)
                      .gettranslatedValue('Home_page_6'),
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
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(
                              color: Colors.blueAccent, fontFamily: 'Dubai'),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
