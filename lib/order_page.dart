
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:departure/utils/static_members.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';
import 'HomePage.dart';
import 'localization/demo_localization.dart';

class OrderPage extends StatefulWidget {
  final double totalPrice;
  final List<Map<String, dynamic>> products;
  final double price_after_discount;
  final String dicount_check;
  final String saved_text;
  final String discount_key;
  OrderPage(
      {this.totalPrice,
        this.products,
        this.price_after_discount,
        this.dicount_check,
        this.saved_text,
        this.discount_key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var _nameController = TextEditingController();
  var _codeController = TextEditingController();
  var _houseNoController = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String _smsCode;
  bool _showLoader = false;
  //static const LatLng _latLng = const LatLng(24.382469, 54.640647);
  bool isChecked = false;
  bool isChecked_diliv1 = false,
      isChecked_diliv2 = false,
      isChecked_diliv3 = false,
      isChecked_diliv4 = false;
  //LocationResult _pickedLocation;
  String apiKey;
  List getsizelist = [];
  List quantity_list = [];
  List namekeylist = [];
  String orderId = "";
  String orderId_discount = "";

  @override
  void initState() {
    super.initState();
  }


  bool isInProgress = false;
  String countrystart = "+971", phoneNo = "", phone;
  var number = TextEditingController();
  String Selected_number = "50";
  List<DropdownMenuItem<String>> list_two_numbers = [];

  int selectedRadioState = 0;
  setSelectedvalue(int value){
    setState(() {
      selectedRadioState = value;
    });
  }

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    setState(() {
      countrystart = countryCode.toString();
    });
  }

  void loads_number() {
    list_two_numbers = [];
    list_two_numbers.add(DropdownMenuItem(child: new Text("50"), value: '50'));
    list_two_numbers.add(DropdownMenuItem(child: new Text("52"), value: '52'));
    list_two_numbers.add(DropdownMenuItem(child: new Text("54",), value: '54'));
    list_two_numbers.add(DropdownMenuItem(child: new Text("55"), value: '55'));
    list_two_numbers.add(DropdownMenuItem(child: new Text("56"), value: '56'));
    list_two_numbers.add(DropdownMenuItem(child: new Text("58"), value: '58'));
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
                    DemoLocalizations.of(context).gettranslatedValue('Home_page_31'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 19, fontFamily: 'Dubai'),
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 20),
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
                        DemoLocalizations.of(context).gettranslatedValue('Home_page_6'),
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
  String _PositionItem;

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
                  DemoLocalizations.of(context).gettranslatedValue('Home_page_6'),
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

  double after_check_code;
  double after_compare;
  String saved_text;

  String type_of_payment;
  int selectedPaymentType = 0;
  int international_cost = 75;

  setSelectedvaluecondition(int value) {
    setState(() {
      selectedPaymentType = value;
    });
  }

  bool in_uae = false, out_uae = false, stop = false, verfied_number = false;
  String location_name;
  List<String> number_of_perfumes = [];
  String selectedLoc = "Location";
  int number_perfume = 0;
  Widget _showPlaceOrderPage() {
    loads_number();
    for (int i = 0; i < widget.products.length; i++) {
      if (!number_of_perfumes.contains(widget.products[i]['itemId'])) {
        number_perfume = number_perfume + widget.products[i]['itemQuantity'];
        number_of_perfumes.add(widget.products[i]['itemId']);
      }
    }
    print(number_perfume.toString());
    if (number_of_perfumes.length <= 2 && number_perfume <= 2) {
      international_cost = 95;
    } else if ((number_of_perfumes.length <= 4 &&
        number_of_perfumes.length > 2) ||
        (number_perfume <= 4 && number_perfume > 2)) {
      international_cost = 125;
    } else if ((number_of_perfumes.length <= 6 &&
        number_of_perfumes.length > 4) ||
        (number_perfume <= 6 && number_perfume > 4)) {
      international_cost = 150;
    } else if ((number_of_perfumes.length <= 8 &&
        number_of_perfumes.length > 6) ||
        (number_perfume <= 8 && number_perfume > 6)) {
      international_cost = 170;
    } else if (number_of_perfumes.length > 8 && number_perfume > 8) {
      international_cost = 260;
    }
    return Form(
      key: _formKey,
      child: ListView(children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 15, 16, 5),
          height: 75,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter your name ";
              }
              return null;
            },
            style: TextStyle(fontFamily: 'Dubai', fontSize: 16),
            controller: _nameController,
            decoration: InputDecoration(
                labelText: "Please enter your name ",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8))),
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            height: 75,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textDirection: ui.TextDirection.ltr,
              children: [
                Container(
                  width: 100,
                  height: 75,
                  alignment: Alignment.centerLeft,
                  child: CountryCodePicker(
                    onChanged: _onCountryChange,
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: 'AE',
                    // optional. Shows only country name and flag
                    showCountryOnly: false,
                    // optional. Shows only country name and flag when popup is closed.
                    showOnlyCountryWhenClosed: false,
                    // optional. aligns the flag and the Text left
                    alignLeft: true,
                    hideSearch: false,
                  ),
                ),
                Builder(builder: (context) {
                  if (countrystart == "+971") {
                    return Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Builder(
                          builder: (context) {
                            return Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Container(
                                width: 150,
                                alignment: Alignment.bottomLeft,
                                height: 65,
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  maxLength: 7,
                                  validator: (value) {
                                    if (phoneNo.isEmpty) {
                                      return DemoLocalizations.of(context).gettranslatedValue('Home_page_34');
                                    } else if (phoneNo.length < 7) {
                                      return DemoLocalizations.of(context).gettranslatedValue('Home_page_34');
                                    } else if (phoneNo.length > 7) {
                                      return DemoLocalizations.of(context).gettranslatedValue('Home_page_34');
                                    }
                                    return null;
                                  },
                                  controller: number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    labelText:
                                    DemoLocalizations.of(context).gettranslatedValue('Home_page_4'),
                                  ),
                                  keyboardType:
                                  TextInputType.numberWithOptions(),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter
                                        .digitsOnly,
                                  ],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16,fontFamily: 'Dubai'),
                                  onChanged: (value) {
                                    setState(() {
                                      this.phoneNo = value.trim();
                                    });
                                    if (value.length == 7) {
                                      //10 is the length of the phone number you're allowing
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Container(
                            width: 50,
                            height: 75,
                            child: new Center(
                              child: DropdownButton(
                                value: Selected_number,
                                items: list_two_numbers,
                                elevation: 75,
                                onChanged: (value) {
                                  setState(() {
                                    Selected_number = value;
                                  });
                                },
                                isExpanded: true,
                                iconSize: 22,
                                hint: Text(
                                  "50",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else
                    return Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Container(
                        width: 175,
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (phoneNo.isEmpty) {
                              return DemoLocalizations.of(context).gettranslatedValue('Home_page_34');
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
                            color: Colors.black,
                          ),
                          onChanged: (value) {
                            setState(() {
                              this.phoneNo = value.trim();
                            });

                          },
                        ),
                      ),
                    );
                }),
              ],
            )),
        SizedBox(
          height: 2,
        ),
        /*
        Builder(
          builder: (context) {
            if (!verfied_number) {
              return Container(
                height: 60,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if (number.text.trim() != "1122330") {
                        if (countrystart == "+971") {
                          phone = countrystart + Selected_number + phoneNo;
                        } else {
                          phone = countrystart + phoneNo;
                        }
                        setState(() {
                          _showLoader = true;
                        });
                        await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phone,
                            timeout: Duration(seconds: 45),
                            verificationCompleted:
                                (AuthCredential authCredential) {
                              debugPrint("Verification completed.");
                            },
                            codeSent: (verId, [forceCodeResend]) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Please enter the OTP "),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextField(
                                            style:
                                            TextStyle(fontFamily: 'Dubai'),
                                            keyboardType: TextInputType.number,
                                            controller: _codeController,
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          color: Colors.black,
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Dubai'),
                                            textAlign: TextAlign.center,
                                          ),
                                          onPressed: () {
                                            _showLoader = false;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            "Next",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Dubai'),
                                            textAlign: TextAlign.center,
                                          ),
                                          textColor: Colors.white,
                                          color: Colors.black,
                                          onPressed: isInProgress
                                              ? Center(
                                              child:
                                              CircularProgressIndicator())
                                              : () {
                                            Dialogs.showLoadingDialog(
                                                context,
                                                _formKey); //invoking login

                                            setState(() {
                                              isInProgress = true;
                                            });
                                            _smsCode = _codeController
                                                .text
                                                .trim();
                                            AuthCredential credential =
                                            PhoneAuthProvider
                                                .getCredential(
                                                verificationId:
                                                verId,
                                                smsCode:
                                                _smsCode);
                                            FirebaseAuth.instance
                                                .signInWithCredential(
                                                credential)
                                                .then((authResult) {
                                              if (authResult.user !=
                                                  null) {
                                                Navigator.of(
                                                    _scaffoldKey
                                                        .currentContext,
                                                    rootNavigator:
                                                    true)
                                                    .pop(); //close the dialoge
                                                Navigator.pop(context);
                                                setState(() {
                                                  verfied_number = true;
                                                  _showLoader = false;
                                                });
                                              } else {
                                                _showLoader = false;
                                                Navigator.of(
                                                    _scaffoldKey
                                                        .currentContext,
                                                    rootNavigator:
                                                    true)
                                                    .pop(); //close the dialoge

                                                Navigator.pop(context);
                                                _scaffoldKey.currentState
                                                    .showSnackBar(
                                                    SnackBar(
                                                      content: Text("There was a problem confirming the number, please try again "),
                                                      duration: Duration(
                                                          seconds: 3),
                                                      backgroundColor:
                                                      Colors.red,
                                                    ));
                                                setState(() {
                                                  _showLoader = false;
                                                });
                                              }
                                            }).catchError((error) {
                                              Navigator.of(
                                                  _scaffoldKey
                                                      .currentContext,
                                                  rootNavigator: true)
                                                  .pop(); //close the dialoge

                                              Navigator.pop(context);
                                              _scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content:
                                                Text(error.message),
                                                duration:
                                                Duration(seconds: 3),
                                                backgroundColor:
                                                Colors.red,
                                              ));

                                              setState(() {
                                                _showLoader = false;
                                              });
                                            });
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                            verificationFailed: (authException) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("authException.message"),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.red,
                              ));
                              setState(() {
                                _showLoader = false;
                              });
                            },
                            codeAutoRetrievalTimeout: (verId) {});
                      } else {
                        setState(() {
                          verfied_number = true;
                        });
                      }
                    }
                  },
                  child: _showLoader
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                    "Confirm number",
                    style: TextStyle(fontFamily: 'Dubai'),
                  ),
                  textColor: Colors.white,
                  color: Colors.black,
                ),
              );
            } else
              return Container();
          },
        ),

         */
        Divider(
          thickness: 2,
        ),
        SizedBox(
          height: 8,
        ),
        /*
        Builder(builder: (context) {
          if (!verfied_number) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () async {
                  _pickedLocation = await showLocationPicker(
                    context,
                    "AIzaSyDGvP-nFXQDa7yibVJLiOycjdLkjayWMOw",
                    initialCenter: _latLng,
                    myLocationButtonEnabled: true,
                    layersButtonEnabled: true,
                  );
                  print(_pickedLocation.toString());
                  //Alsila
                  if (_pickedLocation.latLng.latitude < 24.43967 &&
                      _pickedLocation.latLng.latitude > 24.14004 &&
                      _pickedLocation.latLng.longitude < 51.81129 &&
                      _pickedLocation.latLng.longitude > 51.59388) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alsila';
                    });
                  }
                  else if (_pickedLocation.latLng.latitude < 24.14066 &&
                      _pickedLocation.latLng.latitude > 23.80366 &&
                      _pickedLocation.latLng.longitude < 51.92775 &&
                      _pickedLocation.latLng.longitude > 51.59523) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alsila';
                    });
                  }
                  else if (_pickedLocation.latLng.latitude < 23.80292 &&
                      _pickedLocation.latLng.latitude > 23.72065 &&
                      _pickedLocation.latLng.longitude < 51.92851 &&
                      _pickedLocation.latLng.longitude > 51.87223) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alsila';
                    });
                  } else if (_pickedLocation.latLng.latitude < 24.01340 &&
                      _pickedLocation.latLng.latitude > 23.97365 &&
                      _pickedLocation.latLng.longitude < 52.04098 &&
                      _pickedLocation.latLng.longitude > 51.92769) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alsila';
                      ;
                    });
                  } else if (_pickedLocation.latLng.latitude < 23.97365 &&
                      _pickedLocation.latLng.latitude > 23.71995 &&
                      _pickedLocation.latLng.longitude < 52.22595 &&
                      _pickedLocation.latLng.longitude > 51.92769) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alsila';
                      ;
                    });
                  } else if (_pickedLocation.latLng.latitude < 23.71995 &&
                      _pickedLocation.latLng.latitude > 23.40086 &&
                      _pickedLocation.latLng.longitude < 52.22595 &&
                      _pickedLocation.latLng.longitude > 51.98461) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alsila';
                      ;
                    });
                  }
                  //Alghurbyia
                  else if (_pickedLocation.latLng.latitude < 24.21350 &&
                      _pickedLocation.latLng.latitude > 23.97647 &&
                      _pickedLocation.latLng.longitude < 53.33913 &&
                      _pickedLocation.latLng.longitude > 52.22354) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alghurbyia';
                    });
                  } else if (_pickedLocation.latLng.latitude < 23.97647 &&
                      _pickedLocation.latLng.latitude > 23.35043 &&
                      _pickedLocation.latLng.longitude < 52.71851 &&
                      _pickedLocation.latLng.longitude > 52.22534) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alghurbyia';
                    });
                  } else if (_pickedLocation.latLng.latitude < 23.35043 &&
                      _pickedLocation.latLng.latitude > 22.90701 &&
                      _pickedLocation.latLng.longitude < 54.15355 &&
                      _pickedLocation.latLng.longitude > 52.22534) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alghurbyia';
                    });
                  }
                  //Abu Dhabi and Suwehian
                  else if (_pickedLocation.latLng.latitude < 24.91675 &&
                      _pickedLocation.latLng.latitude > 23.35043 &&
                      _pickedLocation.latLng.longitude < 55.75339 &&
                      _pickedLocation.latLng.longitude > 52.22534) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Abu Dhabi';
                    });
                  } else if (_pickedLocation.latLng.latitude < 24.91737 &&
                      _pickedLocation.latLng.latitude > 24.32552 &&
                      _pickedLocation.latLng.longitude < 55.80509 &&
                      _pickedLocation.latLng.longitude > 55.75339) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'AD borders from Alain side';
                    });
                  } else if (_pickedLocation.latLng.latitude < 24.32494 &&
                      _pickedLocation.latLng.latitude > 24.28880 &&
                      _pickedLocation.latLng.longitude < 55.83037 &&
                      _pickedLocation.latLng.longitude > 55.75314) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alain';
                    });
                  } else if (_pickedLocation.latLng.latitude < 24.26115 &&
                      _pickedLocation.latLng.latitude > 24.23516 &&
                      _pickedLocation.latLng.longitude < 55.75968 &&
                      _pickedLocation.latLng.longitude > 55.75306) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alain';
                    });
                  } else if (_pickedLocation.latLng.latitude < 24.23472 &&
                      _pickedLocation.latLng.latitude > 24.19662 &&
                      _pickedLocation.latLng.longitude < 55.96963 &&
                      _pickedLocation.latLng.longitude > 55.75192) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alain';
                    });
                  } else if (_pickedLocation.latLng.latitude < 24.19651 &&
                      _pickedLocation.latLng.latitude > 24.16075 &&
                      _pickedLocation.latLng.longitude < 55.97212 &&
                      _pickedLocation.latLng.longitude > 55.75304) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alain';
                    });
                  } else if (_pickedLocation.latLng.latitude < 24.16075 &&
                      _pickedLocation.latLng.latitude > 23.96769 &&
                      _pickedLocation.latLng.longitude < 56.01664 &&
                      _pickedLocation.latLng.longitude > 55.52687) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alain';
                    });
                  } else if (_pickedLocation.latLng.latitude < 24.16183 &&
                      _pickedLocation.latLng.latitude > 23.71443 &&
                      _pickedLocation.latLng.longitude < 55.32164 &&
                      _pickedLocation.latLng.longitude > 54.61240) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Alain';
                    });
                  } else if (_pickedLocation.latLng.latitude < 23.71443 &&
                      _pickedLocation.latLng.latitude > 23.10755 &&
                      _pickedLocation.latLng.longitude < 55.35995 &&
                      _pickedLocation.latLng.longitude > 54.61296) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Abu Dhabi desert';
                    });
                  } else if (_pickedLocation.latLng.latitude < 23.10755 &&
                      _pickedLocation.latLng.latitude > 22.62210 &&
                      _pickedLocation.latLng.longitude < 55.23291 &&
                      _pickedLocation.latLng.longitude > 54.62443) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Abu Dhabi desert';
                    });
                  } else if (_pickedLocation.latLng.latitude < 23.71318 &&
                      _pickedLocation.latLng.latitude > 23.37963 &&
                      _pickedLocation.latLng.longitude < 55.54010 &&
                      _pickedLocation.latLng.longitude > 55.36002) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Abu Dhabi desert';
                    });
                  } else if (_pickedLocation.latLng.latitude < 23.71326 &&
                      _pickedLocation.latLng.latitude > 23.58843 &&
                      _pickedLocation.latLng.longitude < 55.58662 &&
                      _pickedLocation.latLng.longitude > 55.54010) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Abu Dhabi desert';
                    });
                  } else if (_pickedLocation.latLng.latitude < 23.87313 &&
                      _pickedLocation.latLng.latitude > 23.71397 &&
                      _pickedLocation.latLng.longitude < 55.56711 &&
                      _pickedLocation.latLng.longitude > 55.52660) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Abu Dhabi desert';
                    });
                  }
                  //Jabal Ali and Hetta
                  else if (_pickedLocation.latLng.latitude < 25.31034 &&
                      _pickedLocation.latLng.latitude > 24.91662 &&
                      _pickedLocation.latLng.longitude < 55.80414 &&
                      _pickedLocation.latLng.longitude > 54.86945) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Jabal Ali and Hetta';
                    });
                  } else if (_pickedLocation.latLng.latitude < 25.00751 &&
                      _pickedLocation.latLng.latitude > 24.88738 &&
                      _pickedLocation.latLng.longitude < 56.38324 &&
                      _pickedLocation.latLng.longitude > 55.80684) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Jabal Ali and Hetta';
                    });
                  } else if (_pickedLocation.latLng.latitude < 24.88769 &&
                      _pickedLocation.latLng.latitude > 24.73573 &&
                      _pickedLocation.latLng.longitude < 56.32300 &&
                      _pickedLocation.latLng.longitude > 55.96030) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Jabal Ali and Hetta';
                    });
                  }
                  //Dubai
                  else if (_pickedLocation.latLng.latitude < 25.31025 &&
                      _pickedLocation.latLng.latitude > 24.91675 &&
                      _pickedLocation.latLng.longitude < 55.80493 &&
                      _pickedLocation.latLng.longitude > 54.86814) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Dubai';
                    });
                  }
                  //Sharjah and Ajman
                  else if (_pickedLocation.latLng.latitude < 25.47899 &&
                      _pickedLocation.latLng.latitude > 25.31025 &&
                      _pickedLocation.latLng.longitude < 55.80480 &&
                      _pickedLocation.latLng.longitude > 55.28878) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Sharjah and Ajman';
                    });
                  }
                  //UAQ and RAK
                  else if (_pickedLocation.latLng.latitude < 26.04898 &&
                      _pickedLocation.latLng.latitude > 25.47899 &&
                      _pickedLocation.latLng.longitude < 56.13681 &&
                      _pickedLocation.latLng.longitude > 55.34913) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'UAQ and RAK';
                    });
                  } else if (_pickedLocation.latLng.latitude < 26.07189 &&
                      _pickedLocation.latLng.latitude > 25.61875 &&
                      _pickedLocation.latLng.longitude < 56.19440 &&
                      _pickedLocation.latLng.longitude > 56.13724) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'UAQ and RAK';
                    });
                  } else if (_pickedLocation.latLng.latitude < 25.61875 &&
                      _pickedLocation.latLng.latitude > 25.48358 &&
                      _pickedLocation.latLng.longitude < 56.44277 &&
                      _pickedLocation.latLng.longitude > 56.13956) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'UAQ and RAK';
                    });
                  }
                  //FUJ and ALdhaid
                  else if (_pickedLocation.latLng.latitude < 25.61875 &&
                      _pickedLocation.latLng.latitude > 25.48358 &&
                      _pickedLocation.latLng.longitude < 56.44277 &&
                      _pickedLocation.latLng.longitude > 56.13956) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'FUJ and ALdhaid';
                    });
                  } else if (_pickedLocation.latLng.latitude < 25.48175 &&
                      _pickedLocation.latLng.latitude > 25.00736 &&
                      _pickedLocation.latLng.longitude < 56.61738 &&
                      _pickedLocation.latLng.longitude > 55.80666) {
                    setState(() {
                      in_uae = true;
                      out_uae = false;
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'FUJ and ALdhaid';
                    });
                  } else {
                    setState(() {
                      in_uae = false;
                      out_uae = true;
                      type_of_payment = "Card";
                      selectedLoc = _pickedLocation.latLng.latitude.toString() +
                          "," +
                          _pickedLocation.latLng.longitude.toString();
                      location_name = 'Out Of UAE';
                    });
                  }

                },
                child: Container(
                  constraints: BoxConstraints(minHeight: 60),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset:
                        Offset(0.0, 0.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.body1,
                      children: [
                        TextSpan(
                          text: selectedLoc == "Location"
                              ? "Please Select Location"
                              : selectedLoc.split(",")[0].substring(0, 5) +
                              "," +
                              selectedLoc.split(",")[1].substring(0, 5) +
                              '\t',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Dubai',
                            fontSize: 18,
                          ),
                        ),
                        WidgetSpan(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text("Location Icon"),

                            /*
                            Icon(
                              Icons.location_on_outlined,
                              size: 28,
                            ),

                             */
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else
            return Container();
        }),


        SizedBox(
          height: 8,
        ),


        Builder(builder: (context) {
          if (verfied_number && in_uae) {
            return Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                controller: _houseNoController,
                style: TextStyle(fontFamily: 'Dubai'),
                decoration: InputDecoration(
                  labelText: "Please enter the house or apartment number ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          } else
            return Container();
        }),

         */
        Builder(builder: (context){
          print(phoneNo.length);
          if(phoneNo.length >= 7){
            return Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: <Widget>[
                Radio(
                  value: 1,
                  groupValue: selectedRadioState,
                  activeColor: Colors.black,
                  onChanged: (val){
                    setSelectedvalue(val);
                    in_uae = true;
                    out_uae = false;
                    location_name = "ABU DHABI";
                  },
                ),
                InkWell(
                  child: Text(DemoLocalizations.of(context).gettranslatedValue('Home_page_339'),style: TextStyle(fontFamily: 'Dubai'),),
                  onTap: (){
                    setSelectedvalue(1);
                    in_uae = true;
                    out_uae = false;
                    location_name = "ABU DHABI";
                  },
                ),
                Radio(
                  value: 2,
                  groupValue: selectedRadioState,
                  activeColor: Colors.black,
                  onChanged: (val){
                    setSelectedvalue(val);
                    in_uae = true;
                    out_uae = false;
                    location_name = "DUBAI";
                  },
                ),
                InkWell(
                  child: Text(DemoLocalizations.of(context).gettranslatedValue('Home_page_340'),style: TextStyle(fontFamily: 'Dubai'),),
                  onTap: (){
                    setSelectedvalue(2);
                    in_uae = true;
                    out_uae = false;
                    location_name = "DUBAI";
                  },
                ),
                Radio(
                  value: 3,
                  groupValue: selectedRadioState,
                  activeColor: Colors.black,
                  onChanged: (val){
                    setSelectedvalue(val);
                    in_uae = true;
                    out_uae = false;
                    location_name = "SHARJAH";
                  },
                ),
                InkWell(
                  child: Text(DemoLocalizations.of(context).gettranslatedValue('Home_page_341'),style: TextStyle(fontFamily: 'Dubai'),),
                  onTap: (){
                    setSelectedvalue(3);
                    in_uae = true;
                    out_uae = false;
                    location_name = "SHARJAH";
                  },
                ),
              ],
            );
          }else return Container();
        }),
        Builder(builder: (context){
          if(phoneNo.length >= 7){
            return Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Radio(
                  value: 4,
                  groupValue: selectedRadioState,
                  activeColor: Colors.black,
                  onChanged: (val){
                    setSelectedvalue(val);
                    in_uae = true;
                    out_uae = false;
                    location_name = "AJMAN";
                  },
                ),
                InkWell(
                  child: Text(DemoLocalizations.of(context).gettranslatedValue('Home_page_342'),style: TextStyle(fontFamily: 'Dubai'),),
                  onTap: (){
                    setSelectedvalue(4);
                    in_uae = true;
                    out_uae = false;
                    location_name = "AJMAN";
                  },
                ),
                Radio(
                  value: 5,
                  groupValue: selectedRadioState,
                  activeColor: Colors.black,
                  onChanged: (val){
                    setSelectedvalue(val);
                    in_uae = true;
                    out_uae = false;
                    location_name = "UMM AL-QUWAIN";
                  },
                ),
                InkWell(
                  child: Text(DemoLocalizations.of(context).gettranslatedValue('Home_page_343'),style: TextStyle(fontFamily: 'Dubai'),),
                  onTap: (){
                    setSelectedvalue(5);
                    in_uae = true;
                    out_uae = false;
                    location_name = "UMM AL-QUWAIN";
                  },
                ),
                Radio(
                  value: 6,
                  groupValue: selectedRadioState,
                  activeColor: Colors.black,
                  onChanged: (val){
                    setSelectedvalue(val);
                    in_uae = true;
                    out_uae = false;
                    location_name = "FUJAIRAH";
                  },
                ),
                InkWell(
                  child: Text(DemoLocalizations.of(context).gettranslatedValue('Home_page_344'),style: TextStyle(fontFamily: 'Dubai'),),
                  onTap: (){
                    setSelectedvalue(6);
                    in_uae = true;
                    out_uae = false;
                    location_name = "FUJAIRAH";
                  },
                ),
              ],
            );
          } else return Container();
        }),
        Builder(builder: (context){
          if(phoneNo.length >= 7){
            return Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Radio(
                  value: 7,
                  groupValue: selectedRadioState,
                  activeColor: Colors.black,
                  onChanged: (val){
                    setSelectedvalue(val);
                    in_uae = true;
                    out_uae = false;
                    location_name = "RAS AL KHAIMAH";
                  },
                ),
                InkWell(
                  child: Text(DemoLocalizations.of(context).gettranslatedValue('Home_page_345'),style: TextStyle(fontFamily: 'Dubai'),),
                  onTap: (){
                    setSelectedvalue(7);
                    in_uae = true;
                    out_uae = false;
                    location_name = "RAS AL KHAIMAH";
                  },
                ),
                Radio(
                  value: 8,
                  groupValue: selectedRadioState,
                  activeColor: Colors.black,
                  onChanged: (val){
                    setSelectedvalue(val);
                    in_uae = false;
                    out_uae = true;
                    location_name = "Out Of UAE";
                  },
                ),
                InkWell(
                  child: Text(DemoLocalizations.of(context).gettranslatedValue('Home_page_346'),style: TextStyle(fontFamily: 'Dubai'),),
                  onTap: (){
                    setSelectedvalue(8);
                    in_uae = false;
                    out_uae = true;
                    location_name = "Out Of UAE";
                  },
                ),
              ],
            );
          }else return Container();
        }),
        Builder(builder: (context){
          if(in_uae){
            return Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                controller: _houseNoController,
                style: TextStyle(fontFamily: 'Dubai'),
                decoration: InputDecoration(
                  labelText: DemoLocalizations.of(context).gettranslatedValue('Home_page_347'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          }else return Container();
        }),

        /*
        Builder(
          builder: (context) {
            if (out_uae) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Thank You For Shopping Through Atyaab. \nPlace Your Order to be transferred to the Payment Portal",
                  style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Please Select Delivery Date and Time",
                  style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
                ),
              );
            }
          },
        ),

         */
        Builder(
          builder: (context) {
            if (in_uae) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        DateTime firt_date;
                        DateTime initial_Date;
                        if (DateTime.now().weekday == 3) {
                          firt_date = DateTime.now().add(Duration(days: 3));
                          initial_Date = DateTime.now().add(Duration(days: 3));
                        } else {
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
                              print(dt.day.toString());
                              if (dt.weekday == 5) {
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
                      child: Container(
                          constraints: BoxConstraints(minHeight: 60),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 4.0,
                                spreadRadius: 1.0,
                                offset: Offset(
                                    0.0, 0.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.body1,
                              children: [
                                TextSpan(
                                  text: selectedDate == "Delivery Date"
                                      ? "${DemoLocalizations.of(context).gettranslatedValue('Home_page_2822')}\t"
                                      : selectedDate,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Dubai',
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      width: 16,
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(
                                      0.0, 0.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Text(
                              DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_291'),
                              style: TextStyle(
                                  fontFamily: 'Dubai',
                                  fontSize: 13.5,
                                  color: isChecked_diliv1
                                      ? Colors.green
                                      : Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: (){
                            if (isChecked_diliv1) {
                              setState(() {
                                isChecked_diliv1 = false;
                              });
                            } else {
                              setState(() {
                                isChecked_diliv1 = true;
                                isChecked_diliv2 = false;
                                isChecked_diliv3 = false;
                                isChecked_diliv4 = false;

                                selectedTime = "10:00 AM - 12:00 PM";
                              });
                            }
                          },
                        ),
                        InkWell(

                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(
                                      0.0, 0.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_292'),
                              style: TextStyle(
                                  fontFamily: 'Dubai',
                                  fontSize: 13.5,
                                  color: isChecked_diliv2
                                      ? Colors.green
                                      : Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: (){
                            if (isChecked_diliv2) {
                              setState(() {
                                isChecked_diliv2 = false;
                              });
                            } else {
                              setState(() {
                                isChecked_diliv1 = false;
                                isChecked_diliv2 = true;
                                isChecked_diliv3 = false;
                                isChecked_diliv4 = false;

                                selectedTime = "12:00 PM - 2:00 PM";
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(
                                      0.0, 0.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_293'),
                              style: TextStyle(
                                  fontFamily: 'Dubai',
                                  fontSize: 13.5,
                                  color: isChecked_diliv3
                                      ? Colors.green
                                      : Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: (){
                            if (isChecked_diliv3) {
                              setState(() {
                                isChecked_diliv3 = false;
                              });
                            } else {
                              setState(() {
                                isChecked_diliv1 = false;
                                isChecked_diliv2 = false;
                                isChecked_diliv3 = true;
                                isChecked_diliv4 = false;

                                selectedTime = "2:00 PM - 4:00 PM";
                              });
                            }
                          },
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(
                                      0.0, 0.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              DemoLocalizations.of(context)
                                  .gettranslatedValue('Home_page_294'),
                              style: TextStyle(
                                  fontFamily: 'Dubai',
                                  fontSize: 13.5,
                                  color: isChecked_diliv4
                                      ? Colors.green
                                      : Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: (){
                            if (isChecked_diliv4) {
                              setState(() {
                                isChecked_diliv4 = false;
                              });
                            } else {
                              setState(() {
                                isChecked_diliv1 = false;
                                isChecked_diliv2 = false;
                                isChecked_diliv3 = false;
                                isChecked_diliv4 = true;

                                selectedTime = "4:00 PM - 7:00 PM";
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else
              return Container();
          },
        ),
        Builder(
          builder: (context) {
            if (in_uae) {
              return SizedBox(
                height: 8,
              );
            } else
              return Container();
          },
        ),
        Builder(
          builder: (context) {
            if (in_uae) {
              return Divider(
                thickness: 2,
              );
            } else
              return Container();
          },
        ),
        Builder(builder: (context) {
          if (in_uae) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                DemoLocalizations.of(context).gettranslatedValue('Home_page_43'),
                style: TextStyle(fontSize: 18, fontFamily: 'Dubai'),
              ),
            );
          } else
            return Container();
        }),
        Builder(
          builder: (context) {
            if (in_uae) {
              return SizedBox(
                height: 8,
              );
            } else
              return Container();
          },
        ),
        Builder(
          builder: (context) {
            if (selectedDate != "Delivery Date" && in_uae) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: selectedPaymentType,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              setSelectedvaluecondition(val);
                              type_of_payment = "Cash";
                            },
                          ),
                          Text(
                            DemoLocalizations.of(context).gettranslatedValue('Home_page_44'),
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Dubai',
                                color: type_of_payment == "Cash"
                                    ? Colors.green
                                    : Colors.black),
                          ),
                        ],
                      ),
                      onTap: () {
                        setSelectedvaluecondition(1);
                        type_of_payment = "Cash";
                      },
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Radio(
                            value: 2,
                            groupValue: selectedPaymentType,
                            activeColor: Colors.green,
                            onChanged: (val) {
                              setSelectedvaluecondition(val);
                              type_of_payment = "Card";
                            },
                          ),
                          Row(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    child: Image.asset("images/Card.png",
                                        height: 20,
                                        width: 40,
                                        fit: BoxFit.contain),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    child: Image.asset("images/ApplePay.png",
                                        height: 20,
                                        width: 40,
                                        fit: BoxFit.contain),
                                  )
                                ],
                              ),
                              Text(
                                  DemoLocalizations.of(context).gettranslatedValue('Home_page_260'),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Dubai',
                                      color: type_of_payment == "Card"
                                          ? Colors.green
                                          : Colors.black))
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        setSelectedvaluecondition(2);
                        type_of_payment = "Card";
                      },
                    ),
                  ],
                ),
              );
            } else
              return Container();
          },
        ),
        SizedBox(
          height: 4,
        ),
        Divider(
          thickness: 2,
        ),
        Builder(
          builder: (context) {
            return Container(
              height: 60,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: (type_of_payment == "Cash" || type_of_payment == "Card")
                    ? Colors.black
                    : Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () async {
                  String random6 = randomAlphaNumeric(6);
                  namekeylist.clear();
                  if (type_of_payment == "Cash" || type_of_payment == "Card") {
                    double total_price = widget.totalPrice;
                    if (location_name == 'Out Of UAE') {
                      total_price = widget.totalPrice - 20 + international_cost;
                    } else
                      total_price = widget.totalPrice;
                    setState(() {
                      _showLoader = true;
                    });
                    if (countrystart == "+971") {
                      phone = countrystart + Selected_number + phoneNo;
                    }
                    else {
                      phone = countrystart + phoneNo;
                    }

                    var data;
                    if (widget.dicount_check == "true") {
                      data = {
                        "totalPrice": total_price,
                        "name": _nameController.text,
                        "phone": phone,
                        "delivery_date": selected,
                        "delivery_time": selectedTime,
                        "houseNo": _houseNoController.text,
                        //"location": selectedLoc.toString(),
                        "products": widget.products,
                        'location_name': "Web",
                        "location_web": location_name,
                        "payment_method": type_of_payment,
                        "order_state": "order_in_progress",
                        "order_id_customer": random6,
                        "Date_of_order": DateTime.now().year.toString() +
                            "/" +
                            DateTime.now().month.toString() +
                            "/" +
                            DateTime.now().day.toString(),
                        "price_after_discount": widget.price_after_discount,
                        "saved_text": widget.saved_text,
                      };
                    }
                    else {
                      data = {
                        "totalPrice": total_price,
                        "name": _nameController.text,
                        "phone": phone,
                        "delivery_date": selected,
                        "delivery_time": selectedTime,
                        "houseNo": _houseNoController.text,
                        //"location": selectedLoc.toString(),
                        "products": widget.products,
                        'location_name': "Web",
                        "location_web": location_name,
                        "payment_method": type_of_payment,
                        "order_state": "order_in_progress",
                        "order_id_customer": random6,
                        "Date_of_order": DateTime.now().year.toString() +
                            "/" +
                            DateTime.now().month.toString() +
                            "/" +
                            DateTime.now().day.toString(),
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
                            if (type_of_payment == "Cash") {
                              await Firestore.instance
                                  .collection("cart")
                                  .document(StaticMembers.userId)
                                  .collection("items")
                                  .getDocuments()
                                  .then((snapshot) {
                                snapshot.documents.forEach((doc) {
                                  doc.reference.delete();
                                });
                              });
                            }
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
                  "Place your order ",
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
        Builder(builder: (context) {
          if (in_uae) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                DemoLocalizations.of(context).gettranslatedValue('Home_page_295'),
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Dubai',
                ),
              ),
            );
          } else if (out_uae) {
            return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Text(
                        DemoLocalizations.of(context).gettranslatedValue('Home_page_259') +
                            "\n" +
                            DemoLocalizations.of(context).gettranslatedValue('Home_page_2599') +
                            international_cost.toString() +
                            DemoLocalizations.of(context).gettranslatedValue('Home_page_50'),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Dubai',
                        ),
                      ),
                    ),
                  ],
                ));
          } else
            return Container();
        }),

        // ignore: deprecated_member_use
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
        //elevation: 10,
        //iconTheme: IconThemeData(color: iconColor()),
        title: Image.asset(
          "images/appbartitle.png",
          width: MediaQuery.of(context).size.width*0.175,
          height: MediaQuery.of(context).size.height*0.1,
          fit: BoxFit.fill,
        ),
        backgroundColor: HexColor("#37558a"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                    String notificationText = "A new Order received: ";
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
    await Firestore.instance
        .collection("shop_users")
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents != null) {
        snapshot.documents.forEach((element) async {
          await Firestore.instance
              .collection("shop_users")
              .document("sskQX2WxMTUY6L4oMPT2yxLzGEF2")
              .collection("tokens")
              .getDocuments()
              .then((snpshot) {
            if (snpshot.documents != null) {
              snpshot.documents.forEach((ele) async {
                Map<String, dynamic> tokenData = ele.data;
                if (owners.containsKey(tokenData['shopOwnerId'])) {
                  if (tokenData['active'] != null &&
                      tokenData['active'] == true) {
                    String notificationText = "A new Order received: ";
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
  //Uri url = Uri.http("fcm.googleapis.com", "/fcm/send");
  String url = 'https://fcm.googleapis.com/fcm/send';
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
  // make POST request
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
            title: "Payment Process",
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
            child: InAppWebView(
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

                      String text = "Thank you. You have successfully completed the payment process." +
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

                      String text = "You have cancelled the payment process." +
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

                      String text = "Your Bill number: " +
                          widget.orderID +
                          " got rejected. Please check your card details";
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
          title: Text("Order Status"),
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
                  "Close",
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
