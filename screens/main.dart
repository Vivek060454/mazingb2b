import 'dart:async';
import 'dart:io';

import 'package:active_ecommerce_flutter/check.dart';
import 'package:active_ecommerce_flutter/custom/common_functions.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart'as badges;
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

import '../Quickorder.dart';
import '../custom/toast_component.dart';
import '../repositories/address_repository.dart';

class Main extends StatefulWidget {
  Main({Key ?key, go_back = true}) : super(key: key);

  late bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  //int _cartCount = 0;

  BottomAppbarIndex bottomAppbarIndex = BottomAppbarIndex();

  CartCounter counter = CartCounter();
  List<dynamic> _shippingAddressList = [];
  fetchShippingAddressList() async {
    if(is_logged_in.$ == false){

    }
    else {
      var addressResponse = await AddressRepository().getAddressList();
      _shippingAddressList.addAll(addressResponse.addresses);

      setState(() {});
    }

    // getSetShippingCost();
  }
  var _children = [];

  fetchAll(){
    getCartCount();
  }

  void onTapped(int i) {
    fetchAll();
    if (!is_logged_in.$ && ( i == 3)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

      return;
    }
    if (_shippingAddressList.length==0 && ( i == 3)) {
      ToastComponent.showDialog('First Login and add Addrese',
         );

      return;
    }


    if(i== 4){
      app_language_rtl.$ ?slideLeftWidget(newPage: Profile(), context: context):slideRightWidget(newPage: Profile(), context: context);
      return;
    }

    setState(() {
      _currentIndex = i;
    });
    //print("i$i");
  }

  getCartCount()async {

    Provider.of<CartCounter>(context, listen: false).getCount();

  }

  void initState() {
    fetchShippingAddressList();
    _children = [
         Home(counter: counter,),
    CategoryList(
         is_base_category: true,

       ),
      QuickOrder(),
      Cart(has_bottomnav: true,from_navigation:true,counter: counter,),
      Profile()
   //    Home(counter: counter,),
   //    CategoryList(
   //      is_base_category: true,
   //
   //    ),
   //    QuickOrder(),
   // Cart(has_bottomnav: true,from_navigation:true,counter: counter,),
   //    Profile()
    ];
    fetchAll();
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async {
        //print("_currentIndex");
        if (_currentIndex != 0) {
          fetchAll();
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          CommonFunctions(context).appExitDialog();
        }
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          extendBody: true,
          body: _children[_currentIndex],
          bottomNavigationBar:
          SizedBox(
            height: 100,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: onTapped,
              currentIndex:_currentIndex,
              backgroundColor: Colors.white.withOpacity(0.95),
              unselectedItemColor: Color.fromRGBO(168, 175, 179, 1),
              selectedItemColor: MyTheme.accent_color,
              selectedLabelStyle: TextStyle(fontWeight:FontWeight.w700,color: MyTheme.accent_color,fontSize: 12 ),
              unselectedLabelStyle: TextStyle(fontWeight:FontWeight.w400,color:Color.fromRGBO(168, 175, 179, 1),fontSize: 12 ),

              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        "assets/home.png",
                        color: _currentIndex == 0
                            ? MyTheme.accent_color
                            : Color.fromRGBO(153, 153, 153, 1),
                        height: 16,
                      ),
                    ),
                    label: 'Home'),
                    // " AppLocalizations.of(context)!.main_screen_bottom_navigation_home"),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        "assets/categories.png",
                        color: _currentIndex == 1
                            ? MyTheme.accent_color
                            : Color.fromRGBO(153, 153, 153, 1),
                        height: 16,
                      ),
                    ),
                    label:'Categories'),
                    // "AppLocalizations.of(context)!.main_screen_bottom_navigation_categories"),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      "assets/carticon.png",
                      color: _currentIndex == 2
                          ? MyTheme.accent_color
                          : Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),
                  ),
                  label: 'Quick Order',
                ),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child:
                      badges.Badge(
                        badgeStyle: badges.BadgeStyle(
                          shape: badges.BadgeShape.circle,
                          badgeColor: MyTheme.accent_color,
                          borderRadius: BorderRadius.circular(10),
                          padding: EdgeInsets.all(5),
                        ),
                        badgeAnimation: badges.BadgeAnimation.slide(
                          toAnimate: false,
                        ),
                        child: Image.asset(
                          "assets/cart.png",
                          color: _currentIndex == 2
                              ? MyTheme.accent_color
                              : Color.fromRGBO(153, 153, 153, 1),
                          height: 16,
                        ),
                        badgeContent: Consumer<CartCounter>(
                          builder: (context, cart, child) {
                            return Text(
                              "${cart.cartCounter}",
                              style:
                              TextStyle(fontSize: 10, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                    label: 'Cart '),
                    // "AppLocalizations.of(context)
                    // !.main_screen_bottom_navigation_cart"),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      "assets/profile.png",
                      color: _currentIndex == 4
                          ? MyTheme.accent_color
                          : Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),
                  ),
                  label:  'Profile '
                  // AppLocalizations.of(context)
                  //     !.main_screen_bottom_navigation_profile,
                ),
              ],
            ),
          ),
        ),


      ),
    );
  }


}
