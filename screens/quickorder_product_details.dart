import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/text_styles.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/common_webview_screen.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/product_reviews.dart';
import 'package:active_ecommerce_flutter/screens/registration.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:active_ecommerce_flutter/ui_elements/list_product_card.dart';
import 'package:active_ecommerce_flutter/ui_elements/mini_product_card.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:expandable/expandable.dart';
import 'dart:ui';
import 'package:flutter_html/flutter_html.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/repositories/wishlist_repository.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/color_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/repositories/chat_repository.dart';
import 'package:active_ecommerce_flutter/screens/chat.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';
import 'package:social_share/social_share.dart';
import 'dart:async';
import 'package:active_ecommerce_flutter/screens/video_description_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:active_ecommerce_flutter/screens/brand_products.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Recently View/Sqldata.dart';
import '../custom/btn.dart';
import '../repositories/address_repository.dart';
import 'category_products.dart';

class QuickordefrProductDetails extends StatefulWidget {
  int? id;

  QuickordefrProductDetails({Key ?key, this.id}) : super(key: key);

  @override
  _QuickordefrProductDetailsState createState() => _QuickordefrProductDetailsState();
}

class _QuickordefrProductDetailsState extends State<QuickordefrProductDetails> with TickerProviderStateMixin{
  bool _showCopied = false;
  String _appbarPriceString = ". . .";
  int _currentImage = 0;
  ScrollController _mainScrollController = ScrollController(initialScrollOffset: 0.0);
  ScrollController _colorScrollController = ScrollController();
  ScrollController _variantScrollController = ScrollController();
  ScrollController _imageScrollController = ScrollController();
  TextEditingController sellerChatTitleController = TextEditingController();
  TextEditingController sellerChatMessageController = TextEditingController();
  TextEditingController _controller = TextEditingController();

  double _scrollPosition=0.0;
var varianttype;
 List<dynamic> vari=[];
  Animation ?_colorTween;
 late AnimationController _ColorAnimationController;

  CarouselController _carouselController = CarouselController();
 late BuildContext loadingcontext;
  //init values

  bool _isInWishList = false;
  var _productDetailsFetched = false;
  var _productDetails = null;
  var _productImageList = [];
  var _colorList = [];
  int _selectedColorIndex = 0;
  var _selectedChoices = [];
  var _choiceString = "";
  var _variant = "";
  bool cartonstatusi=false;
  var _totalPrice;
  var _singlePrice;
  var _singlePriceString;
  int _quantity = 1;
  int currentStock = 0;
  int _estimate=1;
 // int varit;
 double opacity =0;
  int _checkstock=1;
  List<dynamic> _relatedProducts = [];
  bool _relatedProductInit = false;
  List<dynamic> _topProducts = [];
  bool _topProductInit = false;
  String type = "Piece";
  List<dynamic> _shippingAddressList = [];

  @override
  void initState() {
    print('##########################Widget'+widget.id.toString());


    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_ColorAnimationController);

    _mainScrollController.addListener(() {
      _scrollPosition =  _mainScrollController.position.pixels;


      if (_mainScrollController.position.userScrollDirection == ScrollDirection.forward) {

        if (100 > _scrollPosition && _scrollPosition > 1) {

            opacity = _scrollPosition / 100;

        }

        }

        if (_mainScrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (100 > _scrollPosition && _scrollPosition > 1) {

              opacity = _scrollPosition / 100;


            if(100 > _scrollPosition){

                opacity = 1;

            }


          }

        }
      print("opachity{} $_scrollPosition");
          setState((){});
    });
    fetchAll();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      // Check if the tick number is 5
      if (timer.tick == 10) {
        timer.cancel();
        _addItem1();
      }
    });

    super.initState();
  }
  List<Map<String, dynamic>> _journals1 = [];

  bool _isLooading1 = true;
  void _refreshJournals1() async {
    final data = await SQLHelper1.getItems();
    setState(() {
      _journals1 = data;
      _isLooading1 = false;
    });
  }

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
  Future<void> _addItem1() async {
    print('sdf');
    await SQLHelper1.createItem(
        widget.id!,
        _productDetails.thumbnailImage,
        _productDetails.name,
        _productDetails.mainPrice
       );
    print('rgwrtgwrth'+widget.id.toString()+
        _productDetails.thumbnailImage.toString()+
        _productDetails.name+
        _productDetails.mainPrice);
    _refreshJournals1();
    print('kjgfutdsytdfjhjhfdfdcuhgkjgjhgchfgcgj');
  }

  @override
  void dispose() {

    _mainScrollController.dispose();
    _variantScrollController.dispose();
    _imageScrollController.dispose();
    _colorScrollController.dispose();
    super.dispose();
  }

  fetchAll() {
    fetchShippingAddressList();
    fetchProductDetails();
    if (is_logged_in.$ == true) {
      fetchWishListCheckInfo();
    }

  }

  fetchProductDetails() async {
    var productDetailsResponse =
        await ProductRepository().getProductDetails(id: widget.id!);

    if (productDetailsResponse.data!.length > 0) {
      _productDetails = productDetailsResponse.data![0];
      sellerChatTitleController.text =
          productDetailsResponse.data![0].name!;
    }

    setProductDetailValues();

    setState(() {});
  }



  setProductDetailValues() {
    if (_productDetails != null) {

      // _appbarPriceString = _productDetails.price_high_low;
      _quantity=type=='Carton'?1: _productDetails.minQty;
      _checkstock=_productDetails.inStock;
      // varit=_productDetails.categoryId;
      cartonstatusi= _productDetails.cartonStatus;
      _estimate=_productDetails.estimatedShippingDays.days;
      _singlePrice =type=='Carton'?_productDetails.calculableCartonPrice: _productDetails.calculablePrice;
      _singlePriceString = type=='Carton'?_productDetails.cartonPrice:_productDetails.mainPrice;
      calculateTotalPrice();
      currentStock = _productDetails.currentStock;
      _productDetails.photos.forEach((photo) {
        _productImageList.add(photo.path);
      });

      _productDetails.choiceOptions.forEach((choiceOptions) {
        _selectedChoices.add(choiceOptions.options[0]);
      });
      _productDetails.colors.forEach((color) {
        _colorList.add(color);
      });

      setChoiceString();

      if (_productDetails.colors.length > 0 ||
          _productDetails.choiceOptions.length > 0) {
        fetchAndSetVariantWiseInfo(change_appbar_string: true);
      }
      _productDetailsFetched = true;

      setState(() {});
    }
  }

  setChoiceString() {
    _choiceString = _selectedChoices.join(",").toString();
    //print(_choiceString);
    setState(() {});

  }

  fetchWishListCheckInfo() async {
    var wishListCheckResponse =
        await WishListRepository().isProductInUserWishList(
      product_id: widget.id,
    );

    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  addToWishList() async {
    var wishListCheckResponse =
        await WishListRepository().add(product_id: widget.id);

    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  removeFromWishList() async {
    var wishListCheckResponse =
        await WishListRepository().remove(product_id: widget.id);

    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  onWishTap() {
    if (is_logged_in.$ == false) {
      ToastComponent.showDialog('Login first',
          // AppLocalizations.of(context)!.common_login_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    if (_isInWishList) {
      _isInWishList = false;
      setState(() {});
      removeFromWishList();
    } else {
      _isInWishList = true;
      setState(() {});
      addToWishList();
    }
  }

  fetchAndSetVariantWiseInfo({bool change_appbar_string = true}) async {
    print('#####__------#####argse#');
    var color_string = _colorList.length > 0
        ? _colorList[_selectedColorIndex].toString().replaceAll("#", "")
        : "";

    /*print("color string: "+color_string);
    return;*/
    print('#####__------#wefarg#####');
    var variantResponse = await ProductRepository().getVariantWiseInfo(
        id: widget.id!, color: color_string, variants: _choiceString);
print('#####__------######');
    /*print("vr"+variantResponse.toJson().toString());
    return;*/

    _singlePrice = variantResponse.price;
    currentStock = variantResponse.stock!;
    if (_quantity > currentStock) {
      _quantity = currentStock;
      setState(() {});
    }

    _variant = variantResponse.variant!;
    setState(() {});

    calculateTotalPrice();
    _singlePriceString = variantResponse.price_string;

    if (change_appbar_string) {
      // _appbarPriceString = "${variantResponse.variant} ${_singlePriceString}";
    }

    int pindex = 0;
    _productDetails.photos.forEach((photo) {
      //print('con:'+ (photo.variant == _variant && variantResponse.image != "").toString());
      if (photo.variant == _variant && variantResponse.image != "") {
        _currentImage = pindex;
        _carouselController.jumpToPage(pindex);
      }

      pindex++;
    });

    setState(() {});
  }

  reset() {
    restProductDetailValues();
    _currentImage = 0;
    _productImageList.clear();
    _colorList.clear();
    _selectedChoices.clear();
    _relatedProducts.clear();
    _topProducts.clear();
    _choiceString = "";
    _variant = "";
    _selectedColorIndex = 0;
    _quantity = 1;
    _productDetailsFetched = false;
    _isInWishList = false;
    sellerChatTitleController.clear();
    setState(() {});
  }

  restProductDetailValues() {
    _appbarPriceString = " . . .";
    _productDetails = null;
    _productImageList.clear();
    _currentImage = 0;
    setState(() {});
  }
  bool carton= false;
  bool piece= false;
  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }
  calculateprice(){

    print(_controller.text);
    int s=int.parse(_controller.text ) ;
    print(s);
    _totalPrice=(_singlePrice *s).toStringAsFixed(2);
    _quantity=1*s;
    setState(() {});
  }

  calculateTotalPrice() {
    if(type=='Piece'){
      _totalPrice = (_singlePrice * _quantity).toStringAsFixed(2);
      setState(() {});
      print('awrgtg'+_totalPrice);
    }
    if(type=='Carton'){
      _totalPrice = (_singlePrice * _quantity*_productDetails.piecePerCarton).toStringAsFixed(2);
      setState(() {});
      print('awrgtg'+_totalPrice);
    }
    else{}


  }

  _onVariantChange(_choice_options_index, value) {
    _selectedChoices[_choice_options_index] = value;
    setChoiceString();
    setState(() {});
    fetchAndSetVariantWiseInfo();
  }

  _onColorChange(index) {
    _selectedColorIndex = index;
    setState(() {});
    fetchAndSetVariantWiseInfo();
  }

  onPressAddToCart(context, snackbar) {
    addToCart(mode: "add_to_cart", context: context, snackbar: snackbar);
  }

  onPressBuyNow(context) {
    addToCart(mode: "buy_now", context: context);
  }

  addToCart({mode, context = null, snackbar = null}) async {
    if (is_logged_in.$ == false) {
      // ToastComponent.showDialog(AppLocalizations.of(context).common_login_warning, context,
      //     gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }
    if (_shippingAddressList.length == 0) {
      ToastComponent.showDialog('First Login and add Addrese',
          gravity: Toast.center, duration: Toast.lengthLong);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }
    // print(widget.id);
    // print(_variant);
    // print(user_id.$);
    // print(_quantity);

    var typeees='piece';
    var typepiececarton= type=="Carton"?1:0;
    print("####$typepiececarton#####");
    var cartAddResponse = await CartRepository()
        .getCartAddResponse(widget.id!, typeees, _quantity,typepiececarton);

    if (cartAddResponse.result == false) {
      ToastComponent.showDialog(cartAddResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else {

      Provider.of<CartCounter>(context, listen: false).getCount();

      if (mode == "add_to_cart") {
        Navigator.pop(context);
        print('######################jhebfrkhjebgr');
        ToastComponent.showDialog('Added to cart',
            gravity: Toast.center, duration: Toast.lengthLong);

        if (snackbar != null && context != null) {
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
        reset();
        fetchAll();
      } else if (mode == 'buy_now') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Cart(has_bottomnav: false);
        })).then((value) {
          onPopped(value);
        });
      }
    }
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  onCopyTap(setState) {
    setState(() {
      _showCopied = true;
    });
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _showCopied = false;
      });
    });
  }

  onPressShare(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Btn.minWidthFixHeight(
                          minWidth: 75,
                          height: 26,
                          color: Color.fromRGBO(253, 253, 253, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          child: Text('Copy link',
                            // AppLocalizations.of(context)
                            //     !.product_details_screen_copy_product_link,
                            style: TextStyle(
                              color: MyTheme.medium_grey,
                            ),
                          ),
                          onPressed: () {
                            onCopyTap(setState);
                            SocialShare.copyToClipboard(
                            text:_productDetails.link
                            );
                          },
                        ),
                      ),
                      _showCopied
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text('Copied',
                                // AppLocalizations.of(context)!.common_copied,
                                style: TextStyle(
                                    color: MyTheme.medium_grey, fontSize: 12),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Btn.minWidthFixHeight(
                          minWidth: 75,
                          height: 26,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          child: Text('Share option',
                            // AppLocalizations.of(context)
                            //     !.product_details_screen_share_options,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            print("share links ${_productDetails.link}");
                             SocialShare.shareOptions(_productDetails.link);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: app_language_rtl.$
                          ? EdgeInsets.only(left: 8.0)
                          : EdgeInsets.only(right: 8.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 30,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.font_grey, width: 1.0)),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                  ],
                )
              ],
            );
          });
        });
  }

  onTapSellerChat() {
    return showDialog(
        context: context,
        builder: (_) => Directionality(
              textDirection:
                  app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 10),
                contentPadding: EdgeInsets.only(
                    top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
                content: Container(
                  width: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('Seller',
                              // AppLocalizations.of(context)
                              //     !.product_details_screen_seller_chat_title,
                              style: TextStyle(
                                  color: MyTheme.font_grey, fontSize: 12)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            height: 40,
                            child: TextField(
                              controller: sellerChatTitleController,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: 'Enter Title' ,
                                  // AppLocalizations.of(context)
                                  //     !.product_details_screen_seller_chat_enter_title,
                                  hintStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: MyTheme.textfield_grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                              "${'Message'
                                  // AppLocalizations.of(context)!.product_details_screen_seller_chat_messasge
                              } *",
                              style: TextStyle(
                                  color: MyTheme.font_grey, fontSize: 12)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            height: 55,
                            child: TextField(
                              controller: sellerChatMessageController,
                              autofocus: false,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  hintText: 'Enter message',
                                  // AppLocalizations.of(context)
                                  //     !.product_details_screen_seller_chat_enter_messasge,
                                  hintStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: MyTheme.textfield_grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      right: 16.0,
                                      left: 8.0,
                                      top: 16.0,
                                      bottom: 16.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Btn.minWidthFixHeight(
                          minWidth: 75,
                          height: 30,
                          color: Color.fromRGBO(253, 253, 253, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: MyTheme.light_grey, width: 1.0)),
                          child: Text('Close',
                            // AppLocalizations.of(context)
                            //     !.common_close_in_all_capital,
                            style: TextStyle(
                              color: MyTheme.font_grey,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Btn.minWidthFixHeight(
                          minWidth: 75,
                          height: 30,
                          color: MyTheme.accent_color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: MyTheme.light_grey, width: 1.0)),
                          child: Text('Send',
                            // AppLocalizations.of(context)
                            //     !.common_send_in_all_capital,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            onPressSendMessage();

                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
  }
  String get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _controller.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (int.parse(text) >currentStock) {
      return 'Out of stock';
    }

    // return null if the text is valid
    return '';
  }


  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingcontext = context;
          return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text("${'Loading'
                      // AppLocalizations.of(context)!.loading_text
                  }"),
                ],
              ));
        });
  }



  showLoginWarning() {
    return ToastComponent.showDialog('Login first',
        // AppLocalizations.of(context)!.common_login_warning,
        gravity: Toast.center,
        duration: Toast.lengthLong);
  }

  onPressSendMessage() async {
    if(!is_logged_in.$){
      showLoginWarning();
      return;
    }
    loading();
    var title = sellerChatTitleController.text.toString();
    var message = sellerChatMessageController.text.toString();

    if (title == "" || message == "") {
      ToastComponent.showDialog('Enter title or message',
          // AppLocalizations.of(context)
          //     !.product_details_screen_seller_chat_title_message_empty_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    var conversationCreateResponse = await ChatRepository()
        .getCreateConversationResponse(
            product_id: widget.id, title: title, message: message);

    Navigator.of(loadingcontext).pop();

    if (conversationCreateResponse.result == false) {
      ToastComponent.showDialog('Not able to create ',
          // AppLocalizations.of(context)
          //     !.product_details_screen_seller_chat_creation_unable_warning,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    sellerChatTitleController.clear();
    sellerChatMessageController.clear();
    setState(() {});

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Chat(
        conversation_id: conversationCreateResponse.conversation_id,
        messenger_name: conversationCreateResponse.shopName,
        messenger_title: conversationCreateResponse.title,
        messenger_image: conversationCreateResponse.shopLogo,
      );
      ;
    })).then((value) {
      onPopped(value);
    });
  }



  @override
  Widget build(BuildContext context) {


    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SnackBar _addedToCartSnackbar = SnackBar(
      content: Text('Added to cart',
        // AppLocalizations.of(context)
        //     !.product_details_screen_snackbar_added_to_cart,
        style: TextStyle(color: MyTheme.font_grey),
      ),
      backgroundColor: MyTheme.soft_accent_color,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Show cart',
        // AppLocalizations.of(context)
        //     !.product_details_screen_snackbar_show_cart,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Cart(has_bottomnav: false);
          })).then((value) {
            onPopped(value);
          });
        },
        textColor: MyTheme.accent_color,
        disabledTextColor: Colors.grey,
      ),
    );

    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child:  CustomScrollView(
        controller: _mainScrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.white.withOpacity(opacity),
            pinned: true,
            automaticallyImplyLeading: false,
            //titleSpacing: 0,

            expandedHeight: 375.0,
            flexibleSpace: FlexibleSpaceBar(
              background: buildProductSliderImageSection(),
            ),
          ),
          SliverToBoxAdapter(
            child: _productImageList.length==1?Container(): SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(

                  children:[
                    for(var i=0;i<_productImageList.length;i++)...[
                      GestureDetector(
                        onTap: () {},

                        child: Padding(
                          padding: const EdgeInsets.only(left: 13,right: 13),
                          child: Container(
                              height:_currentImage == i?80: 60,
                              width:_currentImage == i?80: 60,
                              decoration: BoxDecoration(
                                color: _currentImage == i
                                    ? MyTheme.font_grey
                                    : Colors.grey.withOpacity(0.2),
                                borderRadius:BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color:_currentImage == i?MyTheme.accent_color:Colors.transparent),
                                //  color:MyTheme.accent_color,
                              ),
                              child: ClipRRect(
                                borderRadius:BorderRadius.all(Radius.circular(10)),

                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image:  _productImageList[i],
                                  fit: BoxFit.cover,
                                ),
                              )
                          ),
                        ),
                      ),

                    ]
                  ]
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              //padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecorations.buildBoxDecoration_1(),
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    EdgeInsets.only(top: 0, left: 0, right: 0),
                    child: _productDetails != null
                        ? Table(
                      columnWidths: {
                        0:FlexColumnWidth(2),
                        1:FlexColumnWidth(4)
                      },
                      children: [
                        TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child:Container(
                                    width: 40,
                                    height: 40,
                                    // color: Colors.blue,
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: ClipRRect(
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/placeholder.png',
                                            image:  _productDetails.brand.logo,
                                            // fit: BoxFit.cover,
                                          )),
                                    )),
                                // Text(
                                //   _productDetails.brand.name,
                                //   style: TextStyle(
                                //       color: MyTheme.font_grey,
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 10),
                                // ),
                              ),
                              Text(
                                _productDetails.name,
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                // maxLines: 2,
                              ),
                            ]
                        )
                      ],
                    )
                        : ShimmerHelper().buildBasicShimmer(
                      height: 30.0,
                    ),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 14, left: 14, right: 14),
                    child: _productDetails != null
                        ? buildRatingAndWishButtonRow()
                        : ShimmerHelper().buildBasicShimmer(
                      height: 30.0,
                    ),
                  ),
                  Padding(
                      padding:
                      EdgeInsets.only(top: 14, left: 14, right: 14),
                      child:RichText(


                        text: TextSpan(
                          text: 'Estimated Shipping Time: ',
                          style: TextStyle(
                              color: Color.fromRGBO(
                                153,
                                153,
                                153,
                                1,
                              ),
                              fontSize: 13),
                          children:  <TextSpan>[
                            TextSpan(
                              text: ' ${_estimate} - ${_estimate+1} days',  style: TextStyle(
                                color: Colors.black,
                                fontSize: 13),),
                          ],
                        ),
                      )),


                  Visibility(
                    visible: club_point_addon_installed.$,
                    child: Padding(
                      padding:
                      EdgeInsets.only(top: 14, left: 14, right: 14),
                      child: _productDetails != null
                          ? buildClubPointRow()
                          : ShimmerHelper().buildBasicShimmer(
                        height: 30.0,
                      ),
                    ),
                  ),
                  Divider(
                    height: 5,
                  ),

                  Table(
                    children: [
                      TableRow(
                          children: [
                            Row(
                              children: [
                                Radio(  value: "Piece",
                                  groupValue: type,
                                  onChanged: (value){
                                    setState(() {
                                      print('sdfsf'+value.toString());

                                      type = value.toString();
                                      fetchProductDetails();
                                    });
                                  },
                                ),
                                Column(
                                  children: [
                                    Text("Order by",style: TextStyle(color:type=='Piece'? MyTheme.accent_color:Colors.grey,fontSize: 13,fontWeight: FontWeight.w300),),
                                    Text("Piece",style: TextStyle(color:type=='Piece'? MyTheme.accent_color:Colors.grey,fontSize: 19,fontWeight: FontWeight.w400),),
                                  ],
                                )
                              ],
                            ),
                            cartonstatusi==false?Container():    Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                children: [
                                  Radio(
                                    value: "Carton",
                                    groupValue: type,
                                    onChanged: (value){
                                      setState(() {
                                        type = value.toString();
                                        fetchProductDetails();
                                        print(value.toString());
                                      });
                                    },
                                  ),
                                  Column(
                                    children: [
                                      Text("Order by",style: TextStyle(color:type=='Carton'? MyTheme.accent_color:Colors.grey,fontSize: 13,fontWeight: FontWeight.w300),),
                                      Text("Carton",style: TextStyle(color:type=='Carton'? MyTheme.accent_color:Colors.grey,fontSize: 19,fontWeight: FontWeight.w400),),

                                    ],
                                  )
                                ],
                              ),
                            ),
                            // Align(
                            //   alignment: Alignment.topLeft,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Column(
                            //         children: [
                            //           Row(
                            //             children: [
                            //               Checkbox(
                            //                 activeColor:piece==true? MyTheme.accent_color:Colors.grey,
                            //                 value: piece,
                            //                 onChanged: (value) {
                            //                   setState(() {
                            //                     piece = value;
                            //                   });
                            //                 },
                            //               ),
                            //               Column(
                            //                 children: [
                            //                   Text("Order by",style: TextStyle(color:piece==true? MyTheme.accent_color:Colors.grey,fontSize: 13,fontWeight: FontWeight.w300),),
                            //                   Text("Piece",style: TextStyle(color:piece==true? MyTheme.accent_color:Colors.grey,fontSize: 19,fontWeight: FontWeight.w400),),
                            //
                            //                 ],
                            //               ),   ],
                            //           ),
                            //           SizedBox(
                            //             height: 10,
                            //           )
                            //
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            //
                            // Align(
                            //   alignment: Alignment.topLeft,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Column(
                            //         children: [
                            //           Row(
                            //             children: [
                            //               Checkbox(
                            //                 activeColor:carton==true? MyTheme.accent_color:Colors.grey,
                            //                 value: carton,
                            //                 onChanged: (value) {
                            //                   setState(() {
                            //                     carton = value;
                            //                   });
                            //                 },
                            //               ),
                            //               Column(
                            //                 children: [
                            //                   Text("Order by",style: TextStyle(color:carton==true? MyTheme.accent_color:Colors.grey,fontSize: 13,fontWeight: FontWeight.w300),),
                            //                   Text("Carton",style: TextStyle(color:carton==true? MyTheme.accent_color:Colors.grey,fontSize: 19,fontWeight: FontWeight.w400),),
                            //
                            //                 ],
                            //               ),   ],
                            //           ),
                            //           SizedBox(
                            //             height: 10,
                            //           )
                            //
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ]
                      ),
                    ],
                  ),


                  Divider(
                    height: 5,
                  ),
                  // Padding(
                  //   padding:
                  //   EdgeInsets.only(top: 14, left: 14, right: 14),
                  //   child: _productDetails != null
                  //       ? buildMainPriceRow()
                  //       : ShimmerHelper().buildBasicShimmer(
                  //     height: 30.0,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 14),
                  //   child: _productDetails != null
                  //       ? buildSellerRow(context)
                  //       : ShimmerHelper().buildBasicShimmer(
                  //           height: 50.0,
                  //         ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 14,
                        left: app_language_rtl.$ ? 0 : 14,
                        right: app_language_rtl.$ ? 14 : 0),
                    child: _productDetails != null
                        ? buildChoiceOptionList()
                        : buildVariantShimmers(),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: 14, left: 14, right: 14),
                    child: _productDetails != null
                        ? (_colorList.length > 0
                        ? buildColorRow()
                        : Container())
                        : ShimmerHelper().buildBasicShimmer(
                      height: 30.0,
                    ),
                  ),

                  Padding(
                    padding:
                    EdgeInsets.only(top: 4, left: 14, right: 14),
                    child: _productDetails != null
                        ? buildQuantityRow()
                        : ShimmerHelper().buildBasicShimmer(
                      height: 30.0,
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //   EdgeInsets.only(top: 4, left: 14, right: 14),
                  //   child: Text(_stock.toString()+'qua'+_quantity.toString()+'piece'+_productDetails.qtyPerPiece.toString()+'carton'+_productDetails.qtyPerCarton.toString())
                  // ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        onPressAddToCart(context, _addedToCartSnackbar);

                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                              color: MyTheme.accent_color
                          ),
                          // width: 30,
                          height: 30,
                          child: Center(
                            child: Row(children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.shopping_cart_outlined,size: 15,color: Colors.white,),
                              Text(' Add to Cart  ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)

                            ]),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  Widget buildSellerRow(BuildContext context) {
    //print("sl:" +  _productDetails.shop_logo);
    return Container(
      color: MyTheme.light_grey,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          _productDetails.addedBy == "admin"
              ? Container()
              : InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SellerDetails(id: _productDetails.shopId,)));

            },
                child: Padding(
                    padding: app_language_rtl.$
                        ? EdgeInsets.only(left: 8.0)
                        : EdgeInsets.only(right: 8.0),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                            color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                        //shape: BoxShape.rectangle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: _productDetails.shopLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ),
          Container(
            width: MediaQuery.of(context).size.width * (.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('/Seller',
                    // AppLocalizations.of(context)!.product_details_screen_seller,
                    style: TextStyle(
                      color: Color.fromRGBO(153, 153, 153, 1),
                    )),
                Text(
                  _productDetails.shopName,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          Spacer(),
          Visibility(
            visible: conversation_system_status.$,
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecorations.buildCircularButtonDecoration_1(),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (is_logged_in == false) {
                            ToastComponent.showDialog("You need to log in",
                                gravity: Toast.center,
                                duration: Toast.lengthLong);
                            return;
                          }

                          onTapSellerChat();
                        },
                        child: Image.asset('assets/chat.png',height: 16,width: 16, color: MyTheme.dark_grey)
                        ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget buildTotalPriceRow() {
    return Container(
      height: 40,
      color: MyTheme.amber,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            child: Padding(

              padding: app_language_rtl.$
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              child: Container(
                width: 75,
                child: Text('Total price',
                  // AppLocalizations.of(context)!.product_details_screen_total_price,
                  style: TextStyle(
                      color: Color.fromRGBO(153, 153, 153, 1), fontSize: 10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              _productDetails.currencySymbol + _totalPrice.toString(),
              style: TextStyle(
                  color: MyTheme.accent_color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Table buildQuantityRow() {
    return
      Table(
      children: [

          TableRow(
            children: [
              is_logged_in.$ == false?Container():      Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price per piece',style: TextStyle(fontSize: 9,fontWeight: FontWeight.w300),),
                    _shippingAddressList.length==0?Text('Starting from '+ _singlePriceString,
                        maxLines: 2, style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)):is_logged_in.$ == false?Text('Starting from '+ _singlePriceString,
                        maxLines: 2, style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)): Text(
                      _singlePriceString,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 19.0,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _productDetails.strokedPrice==_productDetails.mainPrice?Container():  Row(children: [Text('MRP',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300)),
                      _productDetails.discount==0?Container(): Text(_productDetails.strokedPrice,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300,decoration: TextDecoration.lineThrough))])
                  ],
                ),
              ),

              is_logged_in.$ == false?Container(): Align(
                alignment: Alignment.topRight,
                child:_checkstock==0?Container(
                    decoration: BoxDecoration(
                        color: MyTheme.accent_color,
                        borderRadius: BorderRadius.circular(10)
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Out off Stock',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),),
                    )): Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 36,
                      width: 120,
                      /*decoration: BoxDecoration(
                    border:
                        Border.all(color: Color.fromRGBO(222, 222, 222, 1), width: 1),
                    borderRadius: BorderRadius.circular(36.0),
                    color: Colors.white),*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          buildQuantityDownButton(),
                          InkWell(
                            onTap: (){
                            //   showDialog<String>(
                            //       context: context,
                            //       builder: (BuildContext context) =>
                            //           AlertDialog(
                            //             content: Padding(
                            //               padding: const EdgeInsets.all(13.0),
                            //               child: Container(
                            //                 height: 250,
                            //                 child: Column(
                            //                   children: [
                            //                     Padding(
                            //                       padding: const EdgeInsets.all(8.0),
                            //                       child:   Text('Enter Quantity',style: TextStyle(fontSize: 19,fontWeight:FontWeight.w500),),
                            //                     ),
                            //
                            //                     Container(
                            //                       //width: 16,
                            //                         child: Center(
                            //                             child:TextFormField(
                            //                               controller: _controller,
                            //                               maxLength:2,
                            //                               keyboardType: TextInputType.number,
                            //                               // initialValue: _quantity.toString(),
                            //
                            //                               decoration: InputDecoration(
                            //                                   errorText: _errorText,
                            //
                            //
                            //                                   contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            //                                   hintText: "Qty",
                            //                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
                            //
                            //                             ))),
                            //
                            //                     Table(
                            //                       children: [
                            //                         TableRow(
                            //                             children: [
                            //
                            //                               Padding(
                            //                                 padding: const EdgeInsets.all(8.0),
                            //                                 child: ElevatedButton(
                            //                                     onPressed: () {
                            //
                            //                                       Navigator.pop(context);
                            //
                            //                                     },
                            //                                     child: Text('Cancel')),
                            //                               ),
                            //                               Padding(
                            //                                 padding: const EdgeInsets.all(8.0),
                            //                                 child: ElevatedButton(
                            //                                     onPressed: () {
                            //                                       if(int.parse(_controller.text)>_stock){
                            //                                         ToastComponent.showDialog(
                            //                                             'Given Qty is outoff stock',
                            //                                             gravity: Toast.center,
                            //                                             duration: Toast.lengthLong);
                            //                                       }
                            //                                       else{
                            //                                         setState((){});
                            //                                         calculateprice();
                            //
                            //                                         Navigator.pop(context);
                            //
                            //                                       }
                            //
                            //                                     },
                            //                                     child: Text('Next')),
                            //                               ),
                            //                             ]
                            //                         )
                            //                       ],
                            //                     )
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           ));

                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(0)),
                                    color: Color.fromRGBO(154,195,235, 40)
                                ),
                                width: 36,
                                height: 30,
                                child: Center(
                                    child: Text(
                                      _quantity.toString(),
                                      style: TextStyle(fontSize: 18, color: MyTheme.dark_grey),
                                    ))),
                          ),
                          buildQuantityUpButton()
                        ],
                      ),
                    ),
                    // Text('In Stock (${_stock})',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.grey),)
                  ],
                ),
              ),

            ]
        ),
        TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Price',style: TextStyle(fontSize: 9,fontWeight: FontWeight.w300),),
                      is_logged_in.$ == false?InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8,bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: MyTheme.accent_color,
                                borderRadius: BorderRadius.circular(3)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Register to view price',textAlign: TextAlign.center,
                                  maxLines: 2, style: TextStyle(
                                      color:Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ):
                      _shippingAddressList.length==0?Text('Starting from '+ _singlePriceString,
                          maxLines: 2, style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)): Text(
                        _productDetails.currencySymbol + _totalPrice.toString(),
                        style: TextStyle(
                            color: Color.fromRGBO(200,92,26,1),
                            fontSize: 19.0,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                           ],
                  ),
                ),
              ),

               Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _productDetails.strokedPrice==_productDetails.mainPrice?Container():    Text('Congratulations!',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.grey),),
                      _productDetails.strokedPrice==_productDetails.mainPrice?Container():      Text('You saved ${_productDetails.discount}',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.grey),),
type=='Carton'?Align(
    alignment: Alignment.topRight,
    child: Text('Piece Per Carton : ${_productDetails.piecePerCarton}',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.grey))):Container()
                    ],
                  ),
                ),
              ),

            ]
        ),
      ],
    );
      Row(
      children: [
        Padding(
          padding: app_language_rtl.$
              ? EdgeInsets.only(left: 8.0)
              : EdgeInsets.only(right: 8.0),
          child: Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context)!.product_details_screen_quantity,
              style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
            ),
          ),
        ),
        Container(
          height: 36,
          width: 120,
          /*decoration: BoxDecoration(
              border:
                  Border.all(color: Color.fromRGBO(222, 222, 222, 1), width: 1),
              borderRadius: BorderRadius.circular(36.0),
              color: Colors.white),*/
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              buildQuantityDownButton(),
              InkWell(
                onTap: (){
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            content: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Container(
                                height: 250,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:   Text('Enter Quantity',style: TextStyle(fontSize: 19,fontWeight:FontWeight.w500),),
                                    ),

                                    Container(
                                      //width: 16,
                                        child: Center(
                                            child:TextFormField(
                                              controller: _controller,
                                              maxLength:2,
                                              keyboardType: TextInputType.number,
                                              // initialValue: _quantity.toString(),

                                              decoration: InputDecoration(
                                                  errorText: _errorText,


                                                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                                  hintText: "Qty",
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),

                                            ))),

                                    Table(
                                      children: [
                                        TableRow(
                                            children: [

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                    onPressed: () {

                                                      Navigator.pop(context);

                                                    },
                                                    child: Text('Cancel')),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      if(int.parse(_controller.text)>currentStock){
                                                        ToastComponent.showDialog(
                                                            'Given Qty is outoff stock',
                                                            gravity: Toast.center,
                                                            duration: Toast.lengthLong);
                                                      }
                                                      else{
                                                        setState((){});
                                                        calculateprice();

                                                        Navigator.pop(context);

                                                      }

                                                    },
                                                    child: Text('Next')),
                                              ),
                                            ]
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));

                },
                child: Container(
                    width: 36,
                    child: Center(
                        child: Text(
                          _quantity.toString(),
                          style: TextStyle(fontSize: 18, color: MyTheme.dark_grey),
                        ))),
              ),
              buildQuantityUpButton()
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "(${currentStock} ${AppLocalizations.of(context)!.product_details_screen_available})",
            style: TextStyle(
                color: Color.fromRGBO(152, 152, 153, 1), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Padding buildVariantShimmers() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        0.0,
        8.0,
        0.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildChoiceOptionList() {
    return ListView.builder(
      itemCount: _productDetails.choiceOptions.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: buildChoiceOpiton(_productDetails.choiceOptions, index),
        );
      },
    );
  }

  buildChoiceOpiton(choiceOptions, choice_options_index) {
  vari=  choiceOptions[choice_options_index].options;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0.0,
        14.0,
        0.0,
        0.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: app_language_rtl.$
                ? EdgeInsets.only(left: 0.0)
                : EdgeInsets.only(right: 0.0),
            child: Container(
               width: 75,
              child: Text(
                choiceOptions[choice_options_index].title,
                style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
              ),
            ),
          ),



          choiceOptions[choice_options_index].options.length==0?Container():  choiceOptions[choice_options_index].attributeType=='variant'?
          Builder(
              builder: (context) {
                final List<dynamic>varii =choiceOptions[choice_options_index].options;
                var variantee=choiceOptions[choice_options_index].options==null?null:varii[0];
                return Expanded(
                  child: SizedBox(

                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0,bottom: 8),
                      child: Container(
                        // width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(
                              color: MyTheme.accent_color,

                              width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                          child:DropdownButtonHideUnderline(
                            child: DropdownButton(

                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.only(top: 0,bottom: 0,right: 16,left: 0),

                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 10),
                                    child: Row(
                                      children: [

                                        Text(variantee,
                                          style:  GoogleFonts.lato(
                                              textStyle:TextStyle(color:Colors.black)),),
                                      ],
                                    ),
                                  ),
                                ),
                                value: variantee,
                                items:  varii
                                    .map((ite) => DropdownMenuItem(
                                  value: ite,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0,bottom: 0,right: 13,left: 10),
                                    child: Text(ite,
                                      style:  GoogleFonts.lato(
                                          textStyle:TextStyle(color:Colors.black)),),
                                  ),
                                ))
                                    .toList(),
                                onChanged: (items) {

                                  setState(() => variantee = items);
                                  print(variantee+'rgs'+_productDetails.categoryId.toString());
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return CategoryProducts(
                                      category_id: _productDetails.categoryId,
                                      variants: variantee,
                                      category_name: _productDetails.categoryName,
                                    );
                                  }));
                                }
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
          ):   Container(
            // width: MediaQuery.of(context).size.width ,
            child: Scrollbar(
              controller: _variantScrollController,
              isAlwaysShown: false,
              child: Wrap(
                children: List.generate(
                    choiceOptions[choice_options_index].options.length,
                    (index) {
                        return
                        Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                           // width: 75,
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: buildChoiceItem(
                              choiceOptions[choice_options_index]
                                  .options[index],
                              choice_options_index,
                              index),
                        ));}
              ),

              /*ListView.builder(
                itemCount: choice_options[choice_options_index].options.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return
                },
              ),*/
            ),
          )
         )],
      ),
    );
  }

  buildChoiceItem(option, choice_options_index, index) {
    return Padding(
      padding: app_language_rtl.$
          ? EdgeInsets.only(left: 8.0)
          : EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          _onVariantChange(choice_options_index, option);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: _selectedChoices[choice_options_index] == option
                    ? MyTheme.accent_color
                    : MyTheme.noColor,
                width: 1.5),
             borderRadius: BorderRadius.circular(3.0),
            color: MyTheme.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                spreadRadius:1,
                offset: Offset(0.0, 3.0), // shadow direction: bottom right
              )
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
            child: Center(
              child: Text(
                option,
                style: TextStyle(
                    color: _selectedChoices[choice_options_index] == option
                        ? MyTheme.accent_color
                        : Color.fromRGBO(224, 224, 225, 1),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildColorRow() {
    return Row(
      children: [
        Padding(
          padding: app_language_rtl.$
              ? EdgeInsets.only(left: 8.0)
              : EdgeInsets.only(right: 8.0),
          child: Container(
            width: 75,
            child: Text('Color',
              // AppLocalizations.of(context)!.product_details_screen_color,
              style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
            ),
          ),
        ),
        Container(
          alignment:app_language_rtl.$ ?Alignment.centerRight:Alignment.centerLeft,
          height: 40,
          width: MediaQuery.of(context).size.width - (107 + 44),
          child: Scrollbar(
            controller: _colorScrollController,
            child: ListView.separated(
              separatorBuilder: (context,index){
                return SizedBox(width: 10,);
              },
              itemCount: _colorList.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildColorItem(index),
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget buildColorItem(index) {
    return InkWell(
      onTap: () {
        _onColorChange(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: _selectedColorIndex == index ? 30 : 25,
        height: _selectedColorIndex == index ? 30 : 25,
        decoration: BoxDecoration(
          // border: Border.all(
          //     color: _selectedColorIndex == index
          //         ? Colors.purple
          //         : Colors.white,
          //     width: 1),
           borderRadius: BorderRadius.circular(16.0),
          color: ColorHelper.getColorFromColorCode(_colorList[index]),
          boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(_selectedColorIndex == index ?0.25:0.12),
                    blurRadius: 10,
                    spreadRadius: 2.0,
                    offset: Offset(0.0, 6.0), // shadow direction: bottom right
                  )
          ],
        ),
        child: _selectedColorIndex == index
            ? buildColorCheckerContainer()
            : Container(
                height: 25,
              ),
        /*Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
                // border: Border.all(
                //     color: Color.fromRGBO(222, 222, 222, 1), width: 1),
               // borderRadius: BorderRadius.circular(16.0),
                color: ColorHelper.getColorFromColorCode(_colorList[index])),
            child: _selectedColorIndex == index
                ? buildColorCheckerContainer()
                : Container(),
          ),
        ),*/
      ),
    );
  }

  buildColorCheckerContainer() {
    return Padding(
        padding: const EdgeInsets.all(3),
        child: /*Icon(FontAwesome.check, color: Colors.white, size: 16),*/
            Image.asset(
          "assets/white_tick.png",
          width: 16,
          height: 16,
        ));
  }

  Widget buildClubPointRow() {
    return Container(

      constraints: BoxConstraints(maxWidth: 130),
      //width: ,
      decoration: BoxDecoration(
          //border: Border.all(color: MyTheme.golden, width: 1),
          borderRadius: BorderRadius.circular(6.0),
          color:
          //Colors.red,),
          Color.fromRGBO(253, 235, 212, 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

                Row(
                  children: [
                    Image.asset(
                      "assets/clubpoint.png",
                      width: 18,
                      height: 12,
                    ),
                    SizedBox(width: 5,),
                    Text('Earned point',
                      // AppLocalizations.of(context)!.product_details_screen_club_point,
                      style: TextStyle(color: MyTheme.font_grey, fontSize: 10),
                    ),
                  ],
                ),
            Text(
              _productDetails.earnPoint.toString(),
              style: TextStyle(color: MyTheme.golden, fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  Row buildMainPriceRow() {
    return Row(
      children: [
        Text(
          _singlePriceString,
          style: TextStyle(
              color: MyTheme.accent_color,
              fontSize: 16.0,
              fontWeight: FontWeight.w600),
        ),
        Visibility(
          visible: _productDetails.hasDiscount,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(_productDetails.strokedPrice,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Color.fromRGBO(224, 224, 225, 1),
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                )),
          ),
        ),
        Visibility(
          visible: _productDetails.hasDiscount,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "${_productDetails.discount}",
              style: TextStyles.largeBoldAccentTexStyle(),
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
        height: kToolbarHeight +
            statusBarHeight -
            (MediaQuery.of(context).viewPadding.top > 40 ? 32.0 : 16.0),
        //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
        child: Container(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Text(
                _appbarPriceString,
                style: TextStyle(fontSize: 16, color: MyTheme.font_grey),
              ),
            )),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.share_outlined, color: MyTheme.dark_grey),
            onPressed: () {
              onPressShare(context);
            },
          ),
        ),
      ],
    );
  }

 Widget buildBottomAppBar(BuildContext context, _addedToCartSnackbar) {
    return BottomNavigationBar(
      backgroundColor: MyTheme.white.withOpacity(0.9),
      items: [
        BottomNavigationBarItem(
          backgroundColor: Colors.transparent,
          label: '',
          icon: InkWell(
            onTap: () {

              onPressAddToCart(context, _addedToCartSnackbar);
            },
            child: Container(
              margin: EdgeInsets.only(left: 18,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: MyTheme.accent_color,
                boxShadow: [
                  BoxShadow(
                    color: MyTheme.accent_color_shadow,
                    blurRadius: 20,
                    spreadRadius: 0.0,
                    offset:
                        Offset(0.0, 10.0), // shadow direction: bottom right
                  )
                ],
              ),
              height: 50,
              child: Center(
                child: Text('Add cart',
                  // AppLocalizations.of(context)
                  //     !.product_details_screen_button_add_to_cart,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),

        BottomNavigationBarItem(
          label: "",
          icon: InkWell(
            onTap: () {
              onPressBuyNow(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 18,right: 18),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: MyTheme.golden,
                boxShadow: [
                  BoxShadow(
                    color: MyTheme.golden_shadow,
                    blurRadius: 20,
                    spreadRadius: 0.0,
                    offset:
                        Offset(0.0, 10.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Center(
                child: Text('Buy now',
                  // AppLocalizations.of(context)
                  //     !.product_details_screen_button_buy_now,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        )
        /*Container(
          color: Colors.white.withOpacity(0.95),
          height: 83,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 18,
              ),

              SizedBox(
                width: 14,
              ),

              SizedBox(
                width: 18,
              ),
            ],
          ),
        )*/
      ],
    );
  }

  buildRatingAndWishButtonRow() {
    return Row(
      children: [
        RatingBar(
          itemSize: 13.0,
          ignoreGestures: true,
          initialRating: double.parse(_productDetails.rating.toString()),
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: Icon(Icons.star, color: Colors.amber),
            half: Icon(Icons.star_half, color: Colors.amber),
            empty:
                Icon(Icons.star, color: Color.fromRGBO(224, 224, 225, 1)),
          ),
          itemPadding: EdgeInsets.only(right: 1.0),
          onRatingUpdate: (rating) {
            //print(rating);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "(" + _productDetails.ratingCount.toString() + ")",
            style: TextStyle(
                color: Color.fromRGBO(152, 152, 153, 1), fontSize: 10),
          ),
        ),
      ],
    );
  }

  buildBrandRow() {
    return _productDetails.brand.id > 0
        ? InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BrandProducts(
                  id: _productDetails.brand.id,
                  brand_name: _productDetails.brand.name,
                );
              }));
            },
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 0.0),
                  child: Container(
                    width: 75,
                    child: Text('Brand',
                      // AppLocalizations.of(context)!.product_details_screen_brand,
                      style: TextStyle(
                          color: Color.fromRGBO(
                            153,
                            153,
                            153,
                            1,
                          ),
                          fontSize: 10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child:Container(
                      width: 30,
                      height: 30,
                     // color: Colors.blue,
                      child: ClipRRect(
                             child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image:  _productDetails.brand.logo,
                            fit: BoxFit.cover,
                          ))),
                  // Text(
                  //   _productDetails.brand.name,
                  //   style: TextStyle(
                  //       color: MyTheme.font_grey,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 10),
                  // ),
                ),
                /*Spacer(),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                    //shape: BoxShape.rectangle,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: _productDetails.brand.logo,
                        fit: BoxFit.contain,
                      )),
                ),*/
              ],
            ),
          )
        : Container();
  }

  ExpandableNotifier buildExpandableDescription() {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: Container(
                height: 50, child: Html(data: _productDetails.description)),
            expanded: Container(child: Html(data: _productDetails.description)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Builder(
                builder: (context) {
                  var controller = ExpandableController.of(context);
                  return Btn.basic(
                    child: Text(
                      controller!.expanded
                          ? 'View More'
                      // AppLocalizations.of(context)!.common_view_more
                          : 'View Less',
                      // AppLocalizations.of(context)!.common_show_less,
                      style: TextStyle(color: MyTheme.font_grey, fontSize: 11),
                    ),
                    onPressed: () {
                      controller.toggle();
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ));
  }

  buildTopSellingProductList() {
    if (_topProductInit == false && _topProducts.length == 0) {
      return Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
        ],
      );
    } else if (_topProducts.length > 0) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context,index)=>SizedBox(height: 14,),
          itemCount: _topProducts.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(top: 14),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListProductCard(
                id: _topProducts[index].id,
                image: _topProducts[index].thumbnail_image,
                name: _topProducts[index].name,
                main_price: _topProducts[index].main_price,
                stroked_price: _topProducts[index].stroked_price,
                has_discount: _topProducts[index].has_discount);
          },
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text('Top selling product',
                  // AppLocalizations.of(context)
                  //     !.product_details_screen_no_top_selling_product,
                  style: TextStyle(color: MyTheme.font_grey))));
    }
  }

  buildProductsMayLikeList() {
    if (_relatedProductInit == false && _relatedProducts.length == 0) {
      return Row(
        children: [
          Padding(
              padding: app_language_rtl.$
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: app_language_rtl.$
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_relatedProducts.length > 0) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 248,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 16,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: _relatedProducts.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return MiniProductCard(
                  id: _relatedProducts[index].id,
                  image: _relatedProducts[index].thumbnail_image,
                  name: _relatedProducts[index].name,
                  main_price: _relatedProducts[index].main_price,
                  stroked_price: _relatedProducts[index].stroked_price,
                  has_discount: _relatedProducts[index].has_discount);
            },
          ),
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text('No related product',
            // AppLocalizations.of(context)
            //     !.product_details_screen_no_related_product,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  buildQuantityUpButton() => Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        color: Color.fromRGBO(154,195,235, 40)
    ),
    width: 36,
    height: 30,  child: IconButton(
            icon: Icon(Icons.add, size: 16, color: MyTheme.dark_grey),
            onPressed: () {
if(type=="Piece"){
  if (_quantity+_productDetails.minQty <= currentStock){
    _quantity=int.parse((_quantity+_productDetails.minQty) as String);
    setState(() {});
    calculateTotalPrice();
    print('hjgkjwhrtrhfgj'+_productDetails.minQty.toString()+'jhfvb'+currentStock.toString());
  }
  else{

    ToastComponent.showDialog(
        'Maximum product limit reached',
            gravity: Toast.center,
            duration: Toast.lengthLong);

    print('hjgfgj'+_productDetails.minQty.toString()+'jhfvb'+currentStock.toString());
  }

}
if(type=="Carton"){

  if ((currentStock/_productDetails.piecePerCarton).toInt() > _quantity){
    _quantity=_quantity+1;
    setState(() {});
    calculateTotalPrice();
    print('hjgkjwhrtrhfgj'+_productDetails.piecePerCarton.toString()+'jhfvb'+currentStock.toString());
  }
  else{
    ToastComponent.showDialog(
        'Maximum product limit reached',
            gravity: Toast.center,
            duration: Toast.lengthLong);

    print('hjgfgj'+_productDetails.piecePerCarton.toString()+'jhfvb'+currentStock.toString());
  }

}
              // if (_quantity+_productDetails.minQty < _stock) {
              //
              //   if(type=='Piece'){
              //     // _quantity++;
              //     // setState(() {});
              //     // calculateTotalPrice();
              //     _quantity=_quantity+_productDetails.minQty;
              //     setState(() {});
              //     calculateTotalPrice();
              //   }
              //
              //
              // }
              // if (_quantity+_productDetails.qtyPerCarton < _stock) {
              //
              //   if(type=='Carton'){
              //     _quantity=_quantity+_productDetails.qtyPerCarton;
              //     setState(() {});
              //     calculateTotalPrice();
              //   }
              //
              //
              // }
              // else{
              //   ToastComponent.showDialog(
              //       'Out of Stock',
              //       gravity: Toast.center,
              //       duration: Toast.lengthLong);
              //
              // }

            }),
      );

  buildQuantityDownButton() => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        color: Color.fromRGBO(154,195,235, 40)
      ),
      width: 36,
      height: 30,
      child: IconButton(
          icon: Icon(Icons.remove, size: 16, color: MyTheme.dark_grey),
          onPressed: () {
            if(type=='Piece'){
              if(_productDetails.minQty==_quantity){
                ToastComponent.showDialog(
                       'Thats a minimum quantity',
                         gravity: Toast.center,
                         duration: Toast.lengthLong);
                print(_productDetails.minQty.toString()+'jhdfb'+_quantity.toString()+'hgh'+currentStock.toString());
              }
              else{
                _quantity=int.parse((_quantity-_productDetails.minQty) as String);
                setState(() {});
                calculateTotalPrice();
              }

            }
            if(type=='Carton'){
              if(_quantity>1){
                _quantity=_quantity-1;
                setState(() {});
                calculateTotalPrice();
                 }
              else{
                ToastComponent.showDialog(
                         'Thats a minimum quantity',
                           gravity: Toast.center,
                           duration: Toast.lengthLong);
                print(_productDetails.minQty.toString()+'jhdfb'+_quantity.toString()+'hgh'+currentStock.toString());

              }

            }
           //  if(_productDetails.qtyPerCarton==_quantity||_productDetails.minQty==_quantity){
           //    print('dth');
           //    ToastComponent.showDialog(
           //      'Thats a minimum quantity',
           //        gravity: Toast.center,
           //        duration: Toast.lengthLong);
           //  }
           // else{
           //    if(_productDetails.qtyPerCarton<_quantity||_productDetails.minQty<_quantity){
           //      print(_quantity.toString()+"dsvsv");
           //      print(_productDetails.qtyPerCarton.toString()+'sfaer'+_productDetails.minQty.toString());
           //      if(type=='Piece'){
           //        _quantity=_quantity-_productDetails.minQty;
           //        setState(() {});
           //        calculateTotalPrice();
           //      }
           //      else{
           //
           //        _quantity=_quantity-_productDetails.qtyPerCarton;
           //        setState(() {});
           //        calculateTotalPrice();
           //
           //      }
           //
           //
           //    }
           //    else {
           //      print('srg');
           //    }
           //  }

          }));

  openPhotoDialog(BuildContext context, path) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(

            child: Container(

                child: Stack(
              children: [
                PhotoView(

// initialScale:0.3,
                  enableRotation: false,
                  minScale: 0.2,
                  maxScale:1.5,
                  heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                  imageProvider: NetworkImage(path),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: MyTheme.medium_grey_50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: Icon(Icons.clear, color: MyTheme.white),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ),
                ),
              ],
            )),
          );
        },
      );

  buildProductImageSection() {
    if (_productImageList.length == 0) {
      return Row(
        children: [
          Container(
            width: 40,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 190.0,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            width: 64,
            child: Scrollbar(
              controller: _imageScrollController,
              isAlwaysShown: false,
              thickness: 4.0,
              child: Padding(
                padding: app_language_rtl.$
                    ? EdgeInsets.only(left: 8.0)
                    : EdgeInsets.only(right: 8.0),
                child: ListView.builder(
                    itemCount: _productImageList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int itemIndex = index;
                      return GestureDetector(
                        onTap: () {
                          _currentImage = itemIndex;
                          print(_currentImage);
                          setState(() {});
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: _currentImage == itemIndex
                                    ? MyTheme.accent_color
                                    : Color.fromRGBO(112, 112, 112, .3),
                                width: _currentImage == itemIndex ? 2 : 1),
                            //shape: BoxShape.rectangle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  /*Image.asset(
                                        singleProduct.product_images[index])*/
                                  FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: _productImageList[index],
                                fit: BoxFit.contain,
                              )),
                        ),
                      );
                    }),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              openPhotoDialog(context, _productImageList[_currentImage]);
            },
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width - 96,
              child: Container(
                  child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder_rectangle.png',
                image: _productImageList[_currentImage],
                fit: BoxFit.scaleDown,
              )),
            ),
          ),
        ],
      );
    }
  }

 Widget buildProductSliderImageSection() {
    if (_productImageList.length == 0) {
      return ShimmerHelper().buildBasicShimmer(
        height: 190.0,
      );
    } else {
      return Stack(
        children: [CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
              aspectRatio: 355 / 375,
              viewportFraction: 1,
              initialPage: 0,
              autoPlay:_productImageList.length == 1?false: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.easeInExpo,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                print(index);
                setState(() {
                  _currentImage = index;
                });
              }),
          items: _productImageList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  child: Stack(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          openPhotoDialog(
                              context, _productImageList[_currentImage]);
                        },
                        child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder_rectangle.png',
                              image: i,
                              fit: BoxFit.fitHeight,
                            )),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _productImageList.length,
                                (index) => Container(
                                      width: 7.0,
                                      height: 7.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentImage == index
                                            ? MyTheme.font_grey
                                            : Colors.grey.withOpacity(0.2),
                                      ),
                                    ))),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
           ]
      );
    }
  }

  Widget divider() {
    return Container(
      color: MyTheme.light_grey,
      height: 5,
    );
  }
}
