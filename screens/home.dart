import 'package:active_ecommerce_flutter/custom/common_functions.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/data_model/group_categories.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/screens/registration.dart';
import 'package:active_ecommerce_flutter/screens/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/top_selling_products.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:active_ecommerce_flutter/repositories/sliders_repository.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/app_config.dart';

import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/ui_elements/mini_product_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:provider/provider.dart';

import '../Recently View/Sqldata.dart';
import '../data_model/FeaturedCategories.dart';
import '../data_model/best_seller.dart';
import '../data_model/brand.dart';
import '../data_model/delivery_info_response.dart';
import '../data_model/discount.dart';
import '../data_model/newproducts.dart';
import '../data_model/proffesion.dart';
import '../repositories/address_repository.dart';
import '../repositories/group_categories.dart';
import '../repositories/shipping_repository.dart';
import 'FeatureCategoriesAlllist.dart';
import 'brand_products.dart';



class Home extends StatefulWidget {

  Home({Key ?key, this.title, this.show_back_button = false, go_back = true, this.counter})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final CartCounter? counter;

  final String ?title;
  bool ?show_back_button;
  bool ?go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _current_slider = 0;
  final _formKey = GlobalKey<FormState>();
  var name = "";
  var phone = "";
  var message1 = "";
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _messageController = new TextEditingController();

  ScrollController? _allProductScrollController;
  ScrollController ?_featuredCategoryScrollController;
  ScrollController _mainScrollController = ScrollController();

 late AnimationController pirated_logo_controller;
  Animation? pirated_logo_animation;

  var _carouselImageList = [];
  var _bannerOneImageList = [];
  var _bannerTwoImageList = [];
  var _bannerThreeImageList = [];
  var _featuredCategoryList = [];

  Network network=Network();
   Brande? branddata;
   List br=[];
   Group ?userdata;
   List us=[];

   Proffesion? proffesiondata;
   List pr=[];
   Newproduct ?newproductdata;
   List nu=[];
   FeaturedCategoriesList ?categoriesdata;
   List fe=[];
  BestsellerModel? bestseldata;
  List di=[];
  Discountei ?discdata;
  List bi=[];
  bool _isCategoryInitial = true;

  bool _isCarouselInitial = true;
  bool _isBannerOneInitial = true;
  bool _isBannerTwoInitial = true;
  bool _isBannerThreeInitial = true;

  var _featuredProductList = [];
  bool _isFeaturedProductInitial = true;
  int _totalFeaturedProductData = 0;
  int _featuredProductPage = 1;
  bool _showFeaturedLoadingContainer = false;

  var _allProductList = [];
  bool _isAllProductInitial = true;
  int _totalAllProductData = 0;
  int _allProductPage = 1;
  bool _showAllLoadingContainer = false;
  int _cartCount = 0;
  List<Map<String, dynamic>> _journals1 = [];
  List<dynamic> _shippingAddressList = [];


  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshJournals1() async {
    final data = await SQLHelper1.getItems();
    setState(() {
      _journals1 = data;
      _isLoading = false;
    });
  }
  @override
  void initState() {
    // print("app_mobile_language.en${app_mobile_language.$}");
    // print("app_language.${app_language.$}");
    // print("app_language_rtl${app_language_rtl.$}");

    // TODO: implement initState
    super.initState();
    // In initState()
    if (AppConfig.purchase_code == "") {
      initPiratedAnimation();
    }
    _refreshJournals1();
    fetchAll();

    _mainScrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        setState(() {
          _allProductPage++;
        });
        _showAllLoadingContainer = true;
        fetchAllProducts();
      }
    });
  }

  getCartCount() {
    Provider.of<CartCounter>(context, listen: false).getCount();
    //var res = await CartRepository().getCartCount();
    //widget.counter.controller.sink.add(res.count);
  }
  productdat() async {
    newproductdata=await network.newproduct();
    nu=newproductdata!.data;
    setState((){});


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

  disc()async{
    discdata=await network.discount();
    di=discdata!.data;
    setState((){});
}
  branddataa() async {
    branddata=await network.brande();
    br=branddata!.data!;
    setState((){});


  }
  bestseller()async{
  bestseldata=await network.bestseller();
  bi=bestseldata!.data!;

  setState((){});

}
  proffesionaldata() async {
    proffesiondata=await network.professiuon();
    pr=proffesiondata!.data!;
    setState((){});


  }
  categories() async {
    categoriesdata=await network.categoriesfeature();
    fe=categoriesdata!.data;
    setState((){});


  }

  userdataa() async {
    userdata=await network.userData();
    us=userdata!.data;
    setState((){});


  }
  getdata()async{
    setState((){});

  }
  fetchAll() {
    fetchShippingAddressList();
    productdat();
    branddataa();
    proffesionaldata();
    bestseller();
    userdataa();
    disc();
    categories();
    getCartCount();
    getdata();
    fetchCarouselImages();
    fetchBannerOneImages();
    fetchBannerTwoImages();
    fetchBannerThreeImages();
    fetchFeaturedCategories();
    fetchFeaturedProducts();
    fetchAllProducts();
  }

  fetchCarouselImages() async {
    var carouselResponse = await SlidersRepository().getSliders();
    carouselResponse.sliders!.forEach((slider) {
      _carouselImageList.add(slider.photo);
    });
    _isCarouselInitial = false;
    setState(() {});
  }
  clearText() {
    _nameController.clear();
    _phoneController.clear();
    _messageController.clear();
  }
  fetchBannerOneImages() async {
    var bannerOneResponse = await SlidersRepository().getBannerOneImages();
    bannerOneResponse.sliders!.forEach((slider) {
      _bannerOneImageList.add(slider.photo);
    });
    _isBannerOneInitial = false;
    setState(() {});
  }

  fetchBannerTwoImages() async {
    var bannerTwoResponse = await SlidersRepository().getBannerTwoImages();
    bannerTwoResponse.sliders!.forEach((slider) {
      _bannerTwoImageList.add(slider.photo);
    });
    _isBannerTwoInitial = false;
    setState(() {});
  }
  fetchBannerThreeImages() async {
    var bannerThreeResponse = await SlidersRepository().getBannerThreeImages();
    bannerThreeResponse.sliders!.forEach((slider) {
      _bannerThreeImageList.add(slider.photo);
    });
    _isBannerThreeInitial = false;
    setState(() {});
  }

  fetchFeaturedCategories() async {
    var categoryResponse = await CategoryRepository().getFeturedCategories();
    _featuredCategoryList.addAll(categoryResponse.categories!);
    _isCategoryInitial = false;
    setState(() {});
  }

  fetchFeaturedProducts() async {
    var productResponse = await ProductRepository().getFeaturedProducts(
      page: _featuredProductPage,
    );

    _featuredProductList.addAll(productResponse.products as Iterable);
    _isFeaturedProductInitial = false;
    _totalFeaturedProductData = productResponse.meta!.total!;
    _showFeaturedLoadingContainer = false;
    setState(() {});
  }

  fetchAllProducts() async {
    var productResponse =
    await ProductRepository().getFilteredProducts(page: _allProductPage);

    _allProductList.addAll(productResponse.products as Iterable);
    _isAllProductInitial = false;
    _totalAllProductData = productResponse.meta!.total!;
    _showAllLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _carouselImageList.clear();
    _bannerOneImageList.clear();
    _bannerTwoImageList.clear();
    _featuredCategoryList.clear();

    _isCarouselInitial = true;
    _isBannerOneInitial = true;
    _isBannerTwoInitial = true;
    _isCategoryInitial = true;
    _cartCount = 0;

    setState(() {});

    resetFeaturedProductList();
    resetAllProductList();
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  resetFeaturedProductList() {
    _featuredProductList.clear();
    _isFeaturedProductInitial = true;
    _totalFeaturedProductData = 0;
    _featuredProductPage = 1;
    _showFeaturedLoadingContainer = false;
    setState(() {});
  }

  resetAllProductList() {
    _allProductList.clear();
    _isAllProductInitial = true;
    _totalAllProductData = 0;
    _allProductPage = 1;
    _showAllLoadingContainer = false;
    setState(() {});
  }

  initPiratedAnimation() {
    pirated_logo_controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    pirated_logo_animation = Tween(begin: 40.0, end: 60.0).animate(
        CurvedAnimation(
            curve: Curves.bounceOut, parent: pirated_logo_controller));

    pirated_logo_controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        pirated_logo_controller.repeat();
      }
    });

    pirated_logo_controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pirated_logo_controller?.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    //print(MediaQuery.of(context).viewPadding.top);
    return WillPopScope(
      onWillPop: () async {
        CommonFunctions(context).appExitDialog();
        return widget.go_back!;
      },
      child: Directionality(
        textDirection:
        app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: Scaffold(
              key: _scaffoldKey,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(76),
                child: buildAppBar(statusBarHeight, context),
              ),
              //drawer: MainDrawer(),
              body: Stack(
                children: [
                  RefreshIndicator(
                    color: MyTheme.accent_color,
                    backgroundColor: Colors.white,
                    onRefresh: _onRefresh,
                    displacement: 0,
                    child: CustomScrollView(
                      controller: _mainScrollController,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildListDelegate([
                            AppConfig.purchase_code == ""
                                ? Padding(
                              padding: const EdgeInsets.fromLTRB(
                                9.0,
                                16.0,
                                9.0,
                                0.0,
                              ),
                              child: Container(
                                height: 140,
                                color: Colors.black,
                                child: Stack(
                                  children: [
                                    Positioned(
                                        left: 20,
                                        top: 0,
                                        child: AnimatedBuilder(
                                            animation:
                                            pirated_logo_animation!,
                                            builder: (context, child) {
                                              return Image.asset(
                                                "assets/pirated_square.png",
                                                height:
                                                pirated_logo_animation
                                                    !.value,
                                                color: Colors.white,
                                              );
                                            })),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 24.0, left: 24, right: 24),
                                        child: Text(
                                          "This is a pirated app. Do not use this. It may have security issues.",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : Container(),
                           buildHomeCarouselSlider(context),

                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(
                            //     18.0,
                            //     0.0,
                            //     18.0,
                            //     0.0,
                            //   ),
                            //   child: buildHomeMenuRow1(context),
                            // ),
                            // buildHomeBannerOne(context),
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(
                            //     18.0,
                            //     0.0,
                            //     18.0,
                            //     0.0,
                            //   ),
                            //   child: buildHomeMenuRow2(context),
                            // ),
                          ]),
                        ),
                        // SliverList(
                        //   delegate: SliverChildListDelegate([
                        //     Padding(
                        //       padding: const EdgeInsets.fromLTRB(
                        //         18.0,
                        //         20.0,
                        //         18.0,
                        //         0.0,
                        //       ),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             AppLocalizations.of(context)
                        //                 .home_screen_featured_categories,
                        //             style: TextStyle(
                        //                 fontSize: 18,
                        //                 fontWeight: FontWeight.w700),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ]),
                        // ),

                          SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(
                               // height: 350,
                                child: buildHomeFeaturedCategories(context),
                              ),

                            ],
                          ),

                        ),

                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                               buildHomeBannerOne(context),
                            ],
                          ),),

                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                               bestsellingee(),
                            ],
                          ),),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                               sqllist(context),
                            ],
                          ),),


                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                               brandeee(context),
                            ],
                          ),),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                               buildHomeBannerTwo(context),
                            ],
                          ),),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                               groupdemo(context),
                            ],
                          ),),


                        SliverList(
                          delegate: SliverChildListDelegate([
                            Container(
                              color: MyTheme.accent_color,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 280,
                                    width: 480,
                                    child: Image.asset("assets/background_1.png",fit: BoxFit.fill,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 0,
                                            top: 10.0, right: 18.0, left: 18.0),
                                        child: Text(
                                          "Featured product",
                                          // AppLocalizations.of(context)
                                          //     !.home_screen_featured_products,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      buildHomeFeatureProductHorizontalList()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),

                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              proffesiion(),
                            ],
                          ),),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              newproducte(),
                            ],
                          ),),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              buildHomeBannerThree(context)

                            ],
                          ),),
    // SliverList(
    // delegate: SliverChildListDelegate(
    // [
    // discounte(context),
    // ],
    // ),),

                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  key: _formKey,
                                  child: Container(
                                    child: Column(children: [

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text('Looking for Something Specific?',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),),
                                        ),
                                      ),

                                      TextFormField(
                                        controller: _messageController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        // maxLines: 5,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.person),
                                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            hintText: "Products required",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter ";
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      TextFormField(
                                        autofocus: false,
                                        controller: _nameController,
                                        keyboardType: TextInputType.name,
                                        onSaved: (value) {
                                          _nameController.text = value!;
                                        },
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.people_outline),
                                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            hintText: "Full Name",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
                                        validator: (nameController) {
                                          if (nameController!.isEmpty) {
                                            return ("Please enter the name");
                                          }

                                             return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        autofocus: false,
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        onSaved: (value) {
                                          _phoneController.text = value!;
                                        },
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.call),
                                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            hintText: "Phone",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
                                        validator: (_phoneController) {
                                          if (_phoneController!.length!=10) {
                                            return "Please enter the valid phone number";
                                          }
                                          if (_phoneController!.isEmpty) {
                                            return ("Please enter the phone number");
                                          }

                                             return null;
                                        },
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),


                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(

                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(
                                              MyTheme.accent_color,),
                                            ),
                                            onPressed: () {
                                              if (_formKey.currentState!.validate()) {
                                                setState(()  async {
                                                  name = _nameController.text;
                                                  phone = _phoneController.text;
                                                  message1 = _messageController.text;
                                             await  network.postData(name: name,phone: phone,product: message1);

                                                  clearText();

                                                  // Fluttertoast.showToast(
                                                  //     msg: "Message send succesfully");
                                                  // Navigator.of(context).pop(Sellpanelupload);
                                                });
                                              }
                                            },
                                            child: Text(
                                              'Send',
                                              style: TextStyle(fontSize: 16),
                                            )),
                                      )

                                    ],),
                                  ),
                                ),
                              ),

                            ],
                          ),),
                        // SliverList(
                        //   delegate: SliverChildListDelegate(
                        //     [
                        //       buildHomeBannerTwo(context),
                        //     ],
                        //   ),),
                        // SliverList(
                        //   delegate: SliverChildListDelegate([
                        //     Padding(
                        //       padding: const EdgeInsets.fromLTRB(
                        //         18.0,
                        //         15.0,
                        //         20.0,
                        //         0.0,
                        //       ),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             AppLocalizations.of(context)
                        //                 .home_screen_all_products,
                        //             style: TextStyle(
                        //                 fontSize: 18,
                        //                 fontWeight: FontWeight.w700),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     SingleChildScrollView(
                        //       child: Column(
                        //         children: [
                        //           buildHomeAllProducts2(context),
                        //
                        //         ],
                        //       ),
                        //     ),
                        //     Container(
                        //       height: 80,
                        //     )
                        //   ]),
                        // ),
                      ],
                    ),
                  ),
                  // Align(
                  //     alignment: Alignment.center,
                  //     child: buildProductLoadingContainer())
                ],
              )),
        ),
      ),
    );
  }

  Widget  buildHomeAllProducts(context) {
    if (_isAllProductInitial && _allProductList.length == 0) {
      return SingleChildScrollView(
          child: Container());
          // ShimmerHelper().buildProductGridShimmer(
          //     scontroller: _allProductScrollController));
    } else if (_allProductList.length > 0) {
      //snapshot.hasData

      return GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: _allProductList.length,
        controller: _allProductScrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.618),
        padding: EdgeInsets.all(16.0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
            id: _allProductList[index].id,
            image: _allProductList[index].thumbnail_image,
            name: _allProductList[index].name,
            main_price: _allProductList[index].main_price,
            stroked_price: _allProductList[index].stroked_price,
            has_discount: _allProductList[index].has_discount,
            discount: _allProductList[index].discount,
          );
        },
      );
    } else if (_totalAllProductData == 0) {
      return Center(
          child: Text(
              AppLocalizations.of(context)!.common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }
  Widget groupdemo(context) {
    if (us.length == 0) {
      return Container();
      //   Padding(
      //     padding:
      //     const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
      //     child: Container()
      //   // ShimmerHelper().buildBasicShimmer(height: 100)
      // );
    } else if (us.length > 0) {
      return Padding(
        padding: app_language_rtl.$
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 9.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              for(var index=0;index<us.length;index++)...[
                Padding(
                  padding: const EdgeInsets.only(top: 8,bottom: 0,left: 8,right: 8),
                  child: Container(

                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5,bottom: 3,left: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(us[index].name.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for(var i=0;i<us[index].categories.data.length;i++)...[
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap:(){
//                                           if(is_logged_in.$ == false){
//                                             Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
//
//                                           }
// else{
//                                           Navigator.push(context, MaterialPageRoute(builder: (context) {
//                                             return ProductDetails(id: us[index].categories.data[i].id,);
//                                           }));
                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            return CategoryProducts(

                                              category_id: us[index].categories.data[i].id,
                                              category_name: us[index].categories.data[i].name,
                                            );
                                          }));
// }
                                        },
                                        child:   Container(
                                            width: 135,
                                            height:181,
                                            decoration: BoxDecorations.buildBoxDecoration_1(),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Container(
                                                      width: double.infinity,
                                                      child: ClipRRect(
                                                          borderRadius: BorderRadius.vertical(
                                                              top: Radius.circular(6), bottom: Radius.zero),
                                                          child: FadeInImage.assetNetwork(
                                                            placeholder: 'assets/placeholder.png',
                                                            image: us[index].categories.data[i].banner,
                                                            fit: BoxFit.cover,
                                                          ))),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
                                                  child: Text(
                                                    us[index].categories.data[i].name,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: MyTheme.font_grey,
                                                        fontSize: 12,
                                                        height: 1.2,
                                                        fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                                // Padding(
                                                //   padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                //   child: Text(
                                                //     us[index].categories.data[i].mainPrice.toString(),
                                                //     maxLines: 1,
                                                //     style: TextStyle(
                                                //         color: MyTheme.accent_color,
                                                //         fontSize: 16,
                                                //         fontWeight: FontWeight.w700),
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            )
                                        ),

                                      ),
                                    ),


                                  ],
                                ),
                              ]


                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      );

    } else if (!_isCarouselInitial && _carouselImageList.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 0,
      );
    }
  }
  Widget newproducte(){
    if (nu.length == 0) {
       return Container();
      // Padding(
      //     padding:
      //     const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
      //     child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (nu.length > 0) {
      return Container(
        color: MyTheme.accent_color,

        child: Stack(
          children: [

            Container(
              height: 280,
              width: 480,
              child: Image.asset("assets/background_1.png",fit: BoxFit.fill,
              ),
            ),Padding(
            padding: app_language_rtl.$
                ? const EdgeInsets.only(right: 9.0)
                : const EdgeInsets.only(left: 9.0),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('New Products', style: TextStyle(
                      fontSize: 18,color: Colors.white,
                      fontWeight: FontWeight.w700),),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      for(var index=0;index<nu.length;index++)...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap:(){
                              // if(is_logged_in.$ == false){
                              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                              //
                              // }
                              // else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return ProductDetails(id: nu[index].id);
                                }));
                              // }

                            },
                            child: Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(),
                              //   color: Colors.white,
                              // ),

                              child:  SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Container(
                                        width: 135,
                                        decoration: BoxDecorations.buildBoxDecoration_1(),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AspectRatio(
                                              aspectRatio: 1,
                                              child: Container(
                                                  width: double.infinity,
                                                  child:ClipRRect(
                                                      borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(6), bottom: Radius.zero),
                                                      child: FadeInImage.assetNetwork(
                                                        placeholder: 'assets/placeholder.png',
                                                        image:  nu[index].thumbnailImage,
                                                        fit: BoxFit.cover,
                                                      ))),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
                                              child: Text(
                                                nu[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: MyTheme.font_grey,
                                                    fontSize: 12,
                                                    height: 1.2,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                              child:is_logged_in.$ == false?InkWell(
                                                onTap:(){
                                                  if(is_logged_in.$ == false){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));

                                                  }
                                                  else{
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                      return ProductDetails(id: nu[index].id);
                                                    }));
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: MyTheme.accent_color,
                                                      borderRadius: BorderRadius.circular(3)
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Text('Register to view prices',
                                                        maxLines: 2,textAlign: TextAlign.center, style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w500)),
                                                  ),
                                                ),
                                              ): _shippingAddressList.length==0?Text('Starting from '+ nu[index].mainPrice.toString(),
                                                  maxLines: 2, style: TextStyle(
                                                      color: MyTheme.accent_color,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500)):Text(
                                                nu[index].mainPrice.toString(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: MyTheme.accent_color,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        )
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),]
        ),
      );

    } else if ( nu.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 0,
      );
    }
  }
  Widget discounte( context){
    if (di.length == 0) {
      return Container();
    } else if (di.length > 0) {
      return Padding(
        padding: app_language_rtl.$
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 9.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('Discount', style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.w700),),
            // ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  for(var index=0;index<di.length;index++)...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap:(){
                          // Navigator.push(context, MaterialPageRoute(builder: (context) {
                          //   return ProductDetails(id: di[index].id);
                          // }));
                        },
                        child: Container(
                          // decoration: BoxDecoration(
                          //   border: Border.all(),
                          //   color: Colors.white,
                          // ),

                          child:  SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                    width: 190,
                                    decoration: BoxDecorations.buildBoxDecoration_1(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: double.infinity,
                                            child:ClipRRect(
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(6), bottom: Radius.circular(6)),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder: 'assets/placeholder.png',
                                                  image:  di[index].photo,
                                                  fit: BoxFit.cover,
                                                ))),


                                      ],
                                    )
                                ),


                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      );

    } else if ( di.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 0,
      );
    }
  }
  Widget brandeee(context){
    if (br.length == 0) {
      return Container();
        // Padding(
        //   padding:
        //   const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
        //   child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (br.length > 0) {
      return Container(
        color: Color.fromRGBO(254,204,45,1),
        child: Padding(
          padding: app_language_rtl.$
              ? const EdgeInsets.only(right: 9.0)
              : const EdgeInsets.only(left: 9.0,right: 9),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15,bottom: 8,left: 8,right: 8),
                            child: Text('Search by Brands', style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900),),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      MyTheme.accent_color),
                                ),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return Filter(
                                      selected_filter: "brands",
                                    );
                                  }));
                                }, child: Text('View All',style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700))),
                          )
                        ]
                    )
                  ],
                ),
              ),


              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    for(var index=0;index<br.length;index++)...[
                      Padding(
                        padding: const EdgeInsets.only(top: 2,bottom: 8,left: 0,right: 0),
                        child: InkWell(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(id: br[index].id,brand_name:br[index].name,);
                            }));
                          },
                          child: Container(

                            color: Colors.white,
                            child:  SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4,bottom: 4,left: 0,right: 0),
                                    child: Container(
                                       width:165,
                                        height: 165,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide( //                   <--- right side
                                              color: Color.fromRGBO(242, 243, 248, 1),
                                              width: 1.0,
                                            ),
                                          ),
                                          color: Colors.white,

                                        ),
                                        child: Column(
                                          children: [
                                            Container(

                                              // width: double.infinity,
                                                height: 150,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(0), bottom: Radius.zero),
                                                    child: FadeInImage.assetNetwork(
                                                      placeholder: 'assets/placeholder.png',
                                                      image: br[index].logo,
                                                      // fit: BoxFit.scaleDown,
                                                    ))),

                                            // Center(
                                            //   child: Container(
                                            //   //  width: double.infinity,
                                            //     child: ClipRRect(
                                            //
                                            //         borderRadius: BorderRadius.vertical(
                                            //             top: Radius.circular(6), bottom: Radius.zero),
                                            //         child: FadeInImage.assetNetwork(
                                            //           placeholder: 'assets/placeholder.png',
                                            //           image: br[index].logo,
                                            //          // fit: BoxFit.cover,
                                            //         )),
                                            //   ),
                                            // ),
                                            //Text(br[index].name),
                                          ],
                                        )
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      );

    } else if ( br.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 0,
      );
    }
  }
  Widget proffesiion(){
    if (pr.length == 0) {
      return Container();
        // Padding(
        //   padding:
        //   const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
        //   child:Container()
        // ShimmerHelper().buildBasicShimmer(height: 120)
      // );
    } else if (pr.length > 0) {
      return Padding(
        padding: app_language_rtl.$
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 9.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                  child: Text('Search by Profession', style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700),),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      for(var index=0;index<pr.length;index++)...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap:(){
                              print(pr[index].name.toString());
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return Filter(
                                    selected_filter: "product",
                                    serachkey: pr[index].name.toString()
                                );
                              }));


                            },
                            child: Container(


                              child:  SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8,bottom: 0,left: 2,right: 2),
                                      child: Container(
                                          width:130,
                                          // height: 200,
                                          child: Column(
                                            children: [
                                              AspectRatio(

                                                aspectRatio: 0.8,
                                                child: Container(
                                                  width: double.infinity,
                                                  child: pr[index].logo==null?Container():ClipRRect(

                                                      borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(6), bottom: Radius.zero),
                                                      child: FadeInImage.assetNetwork(
                                                        placeholder: 'assets/placeholder.png',
                                                        image: pr[index].logo,width: 130,height: 160,
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6.0),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(.08),
                                                      blurRadius: 20,
                                                      spreadRadius: 0.0,
                                                      offset: Offset(0.0, 10.0), // shadow direction: bottom right
                                                    )
                                                  ],
                                                ),

                                                child:
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
                                                  child: Center(
                                                    child: Text(
                                                      pr[index].name,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: MyTheme.font_grey,
                                                          fontSize: 12,
                                                          height: 1.2,
                                                          fontWeight: FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              // Center(child: Text(pr[index].name))),
                                            ],
                                          )
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

    } else if ( pr.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 0,
      );
    }
  }
  Widget  buildHomeFeaturedCategories(context) {
    if ( fe.length == 0) {
      return Container();
        // ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
        //   crossAxisSpacing: 14.0,
        //   mainAxisSpacing: 14.0,
        //   item_count: 3,
        //   mainAxisExtent: 170.0,
        //   controller: _featuredCategoryScrollController);
    } else if (fe.length > 0) {
      //snapshot.hasData
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              25.0,
              20.0,
              18.0,
              0.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text('Featured Categories',
                // AppLocalizations.of(context)
                //     !.home_screen_featured_categories,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          GridView.builder(
            physics: ScrollPhysics(),
              shrinkWrap: true,
             padding:
              const EdgeInsets.only(left: 18, right: 18, top: 13, bottom: 20),
              // scrollDirection: Axis.vertical,
              controller: _featuredCategoryScrollController,
              itemCount: fe.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // childAspectRatio: 3 / 2,
                // crossAxisSpacing: 14,
                // mainAxisSpacing: 14,
                // mainAxisExtent: 170.0
              ),
              itemBuilder: (context, index) {

                return  GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return CategoryProducts(
                        category_id: fe[index].id,
                        category_name: fe[index].name,
                      );
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      decoration: BoxDecorations.buildBoxDecoration_1(),
                      child: Column(
                        children: <Widget>[
                          Container(
                             // height: 80,
                              child:    AspectRatio(
                                aspectRatio: 1.5,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(6), right: Radius.circular(6)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/placeholder.png',
                                      image: fe[index].banner ,
                                      fit: BoxFit.cover,
                                    )),
                              )),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  fe[index].name,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: true,
                                  style:
                                  TextStyle(fontSize: 11, color: MyTheme.font_grey),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              }),
          Padding(
            padding: const EdgeInsets.only(bottom: 13,left: 13,right: 13),
            child: InkWell(
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryList(
                  is_base_category: true,

                ),));
              },
              child: Container(
                width: 460,
                height: 40,
                decoration: BoxDecoration(
                    color: MyTheme.accent_color
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('View More', style: TextStyle(
                        fontSize: 15,color: Colors.white,
                        fontWeight: FontWeight.w500),),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    } else if ( fe.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.home_screen_no_category_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 0,
      );
    }
  }
  Widget sqllist(context){
    if (_journals1.length == 0) {
      return Container();
    } else if (_journals1.length > 0) {
      return Container(

        child: Padding(
          padding: app_language_rtl.$
              ? const EdgeInsets.only(right: 9.0)
              : const EdgeInsets.only(left: 9.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                            child: Text('Recently Viewed', style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700),),
                          ),

                        ]
                    )
                  ],
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    for(var index=0;index<_journals1.length;index++)...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap:(){
                            // if(is_logged_in.$ == false){
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                            //
                            // }else{


                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ProductDetails(id: _journals1[index]['ide']);
                            }));
                          // }
                          },
                          child: Container(
                            // decoration: BoxDecoration(
                            //   border: Border.all(),
                            //   color: Colors.white,
                            // ),

                            child:  SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                      width: 135,
                                      decoration: BoxDecorations.buildBoxDecoration_1(),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1,
                                            child: Container(
                                                width: double.infinity,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(6), bottom: Radius.zero),
                                                    child: FadeInImage.assetNetwork(
                                                      placeholder: 'assets/placeholder.png',
                                                      image:  _journals1[index]['Image'],
                                                      fit: BoxFit.cover,
                                                    ))),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
                                            child: Text(
                                              _journals1[index]['title'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: MyTheme.font_grey,
                                                  fontSize: 12,
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child:is_logged_in.$ == false?InkWell(
                                              onTap: (){
                                                if(is_logged_in.$ == false){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));

                                                }
                                                else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return ProductDetails(id: nu[index].id);
                                                  }));
                                                }
                                              },
                                              child: Container(
                                                 decoration: BoxDecoration(
                                                     color: MyTheme.accent_color,
                                                     borderRadius: BorderRadius.circular(3)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text('Register to view prices',
                                                      maxLines: 2,textAlign: TextAlign.center, style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500)),
                                                ),
                                              ),
                                            ):_shippingAddressList.length==0?Text('Starting from '+    _journals1[index]['price'],
                                                maxLines: 2, style: TextStyle(
                                                    color: MyTheme.accent_color,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500)): Text(
                                              _journals1[index]['price'],
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: MyTheme.accent_color,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      )
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      );

    } else if ( _journals1.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        //height: 100,
      );
    }
  }

  Widget buildHomeAllProducts2(context) {
    if (_isAllProductInitial && _allProductList.length == 0) {
      return Container();
        // SingleChildScrollView(
        //   child: ShimmerHelper().buildProductGridShimmer(
        //       scontroller: _allProductScrollController));
    } else if (_allProductList.length > 0) {
      return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          itemCount: _allProductList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20.0, bottom: 10, left: 18, right: 18),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ProductCard(
              id: _allProductList[index].id,
              image: _allProductList[index].thumbnail_image,
              name: _allProductList[index].name,
              main_price: _allProductList[index].main_price,
              stroked_price: _allProductList[index].stroked_price,
              has_discount: _allProductList[index].has_discount,
              discount: _allProductList[index].discount,
            );
          });
    } else if (_totalAllProductData == 0) {
      return Container();
        //Center(
      //     child: Text(
      //         AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }



  Widget buildHomeFeatureProductHorizontalList() {
    if (_isFeaturedProductInitial == true && _featuredProductList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 160) / 3)),
        ],
      );
    } else if (_featuredProductList.length > 0) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 248,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                setState(() {
                  _featuredProductPage++;
                });
                fetchFeaturedProducts();
              }
              return true;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(18.0),
              separatorBuilder: (context, index) => SizedBox(
                width: 14,
              ),
              itemCount: _totalFeaturedProductData > _featuredProductList.length
                  ? _featuredProductList.length + 1
                  : _featuredProductList.length,
              scrollDirection: Axis.horizontal,
              //itemExtent: 135,

              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                return (index == _featuredProductList.length)
                    ? SpinKitFadingFour(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    );
                  },
                )
                    : MiniProductCard(
                    id: _featuredProductList[index].id,
                    image: _featuredProductList[index].thumbnail_image,
                    name: _featuredProductList[index].name,
                    main_price: _featuredProductList[index].main_price,
                    stroked_price:
                    _featuredProductList[index].stroked_price,
                    has_discount: _featuredProductList[index].has_discount);
              },
            ),
          ),
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context)
                    !.product_details_screen_no_related_product,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    }
  }

  Widget  buildHomeMenuRow1(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TodaysDealProducts();
              }));
            },
            child: Container(
              height: 90,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/todays_deal.png")),
                  ),
                  Text(AppLocalizations.of(context)!.home_screen_todays_deal,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(132, 132, 132, 1),
                          fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 14.0),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FlashDealList();
              }));
            },
            child: Container(
              height: 90,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/flash_deal.png")),
                  ),
                  Text(AppLocalizations.of(context)!.home_screen_flash_deal,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(132, 132, 132, 1),
                          fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildHomeMenuRow2(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CategoryList(
                  is_top_category: true,
                );
              }));
            },
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width / 3 - 4,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/top_categories.png")),
                  ),
                  Text(
                    AppLocalizations.of(context)!.home_screen_top_categories,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(132, 132, 132, 1),
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 14.0,
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  selected_filter: "brands",
                );
              }));
            },
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width / 3 - 4,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/brands.png")),
                  ),
                  Text(AppLocalizations.of(context)!.home_screen_brands,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(132, 132, 132, 1),
                          fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 14.0,
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TopSellingProducts();
              }));
            },
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width / 3 - 4,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/top_sellers.png")),
                  ),
                  Text(AppLocalizations.of(context)!.home_screen_top_sellers,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(132, 132, 132, 1),
                          fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget bestsellingee(){
    if (bi.length == 0) {
      return Container();
        // Padding(
        //   padding:
        //   const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
        //   child: Container()
        // ShimmerHelper().buildBasicShimmer(height: 10)
      // );
    } else if (bi.length > 0) {
      return Container(
        color: MyTheme.accent_color,
        child: Stack(
          children: [
            Container(
              height: 280,
              width: 480,
              child: Image.asset("assets/background_1.png",fit: BoxFit.fill,
              ),
            ),
            Padding(
            padding: app_language_rtl.$
                ? const EdgeInsets.only(right: 9.0)
                : const EdgeInsets.only(left: 9.0),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Best Selling', style: TextStyle(
                      fontSize: 18,color: Colors.white,
                      fontWeight: FontWeight.w700),),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      for(var index=0;index<bi.length;index++)...[

                        Padding(
                          padding: const EdgeInsets.only(top: 8,bottom: 16,left: 8,right: 8),
                          child: InkWell(
                            onTap:(){
                              // if(is_logged_in.$ == false){
                              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                              //
                              // }
                              // else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return ProductDetails(id: bi[index].id);
                              }));
                              // }
                            },
                            child: Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(),
                              //   color: Colors.white,
                              // ),

                              child:  SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Container(
                                        width: 135,
                                        decoration: BoxDecorations.buildBoxDecoration_1(),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AspectRatio(
                                              aspectRatio: 1,
                                              child: Container(
                                                  width: double.infinity,
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(6), bottom: Radius.zero),
                                                      child: FadeInImage.assetNetwork(
                                                        placeholder: 'assets/placeholder.png',
                                                        image:  bi[index].thumbnailImage,
                                                        fit: BoxFit.cover,
                                                      ))),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(8, 4, 8, 6),
                                              child: Text(
                                                bi[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: MyTheme.font_grey,
                                                    fontSize: 12,
                                                    height: 1.2,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                              child: is_logged_in.$ == false?InkWell(
                                                onTap:(){
                                                  if(is_logged_in.$ == false){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));

                                                  }
                                                  else{
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                      return ProductDetails(id: nu[index].id);
                                                    }));
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: MyTheme.accent_color,
                                                      borderRadius: BorderRadius.circular(3)
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Text('Register to view prices',
                                                        maxLines: 2,textAlign: TextAlign.center, style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w500)),
                                                  ),
                                                ),
                                              ): _shippingAddressList.length==0?Text('Starting from '+    bi[index].mainPrice.toString(),
                                                  maxLines: 2, style: TextStyle(
                                                      color: MyTheme.accent_color,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500)):Text(
                                                bi[index].mainPrice.toString(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: MyTheme.accent_color,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),]
        ),
      );

    } else if (nu.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 0,
      );
    }
  }
  Widget  buildHomeCarouselSlider(context) {
    if (_isCarouselInitial && _carouselImageList.length == 0) {
      return Container();
      // Padding(
      //   padding:
      //       const EdgeInsets.only(left: 18, right: 18, top: 0, bottom: 20),
      //   child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (_carouselImageList.length > 0) {
      return Stack(
          children: [CarouselSlider(
            options: CarouselOptions(
                aspectRatio: 338 / 140,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 1000),
                autoPlayCurve: Curves.easeInExpo,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current_slider = index;
                  });
                }),
            items: _carouselImageList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, top: 0, bottom: 0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          //color: Colors.amber,
                            width: double.infinity,
                            decoration: BoxDecorations.buildBoxDecoration_1(),
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder_rectangle.png',
                                  image: i,
                                   height: 140,
                                  fit: BoxFit.cover,
                                ))),

                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
            Padding(

              padding: const EdgeInsets.only(top: 100),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _carouselImageList.map((url) {
                    int index = _carouselImageList.indexOf(url);
                    return Container(
                      width: 7.0,
                      height: 7.0,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current_slider == index
                            ? MyTheme.white
                            : Color.fromRGBO(112, 112, 112, .3),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ]
      );
    } else if (!_isCarouselInitial && _carouselImageList.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 0,
      );
    }
  }

  Widget  buildHomeBannerOne(context) {
    if (_isBannerOneInitial && _bannerOneImageList.length == 0) {
      return Container();
        // Padding(
        //   padding:
        //   const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 20),
        //   child: ShimmerHelper().buildBasicShimmer(height: 0));
    } else if (_bannerOneImageList.length > 0) {
      return Padding(
        padding: app_language_rtl.$
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 9.0),
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 270 / 120,
              viewportFraction: .75,
              initialPage: 0,
              // padEnds: false,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current_slider = index;
                });
              }),
          items: _bannerOneImageList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 9.0, right: 9, top: 20.0, bottom: 20),
                  child: Container(
                    //color: Colors.amber,
                    width: double.infinity,
                    decoration: BoxDecorations.buildBoxDecoration_1(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder_rectangle.png',
                        image: i,
                        fit: BoxFit.cover,
                      ),),),
                );
              },
            );
          }).toList(),
        ),
      );
    } else if (!_isBannerOneInitial && _bannerOneImageList.length == 0) {
      return Container(
        // height: 10,
        // child: Center(
        //     child: Text(
        //   AppLocalizations.of(context).home_screen_no_carousel_image_found,
        //   style: TextStyle(color: MyTheme.font_grey),
        // ))
      );
    } else {
      // should not be happening
      return Container(
        //height: 10,
      );
    }
  }

  Widget buildHomeBannerTwo(context) {
    if (_isBannerTwoInitial && _bannerTwoImageList.length == 0) {
      return Container();
        // Padding(
        //   padding:
        //   const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
        //   child: ShimmerHelper().buildBasicShimmer(height: 0));
    } else if (_bannerTwoImageList.length > 0) {
      return Padding(
        padding: app_language_rtl.$
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 9.0),
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 270 / 120,
              viewportFraction: 0.7,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.easeInExpo,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current_slider = index;
                });
              }),
          items: _bannerTwoImageList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 9.0, right: 9, top: 15.0, bottom: 15),
                  child: Container(
                      width: double.infinity,

                      decoration: BoxDecorations.buildBoxDecoration_1(),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: i,
                            fit: BoxFit.fill,
                          ))),
                );
              },
            );
          }).toList(),
        ),
      );
    } else if (!_isCarouselInitial && _carouselImageList.length == 0) {
      return Container(
          height: 0,
          // child: Center(
          //     child: Text(
          //       AppLocalizations.of(context).home_screen_no_carousel_image_found,
          //       style: TextStyle(color: MyTheme.font_grey),
          //     ))
      );
    } else {
      // should not be happening
      return Container(
        height: 0,
      );
    }
  }
  Widget buildHomeBannerThree(context) {
    if (_isBannerThreeInitial && _bannerThreeImageList.length == 0) {
      return Container();
        // Padding(
        //   padding:
        //   const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
        //   child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (_bannerThreeImageList.length > 0) {
      return Padding(
        padding: app_language_rtl.$
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 9.0),
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 270 / 120,
              viewportFraction: 0.7,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.easeInExpo,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current_slider = index;
                });
              }),
          items: _bannerThreeImageList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 9.0, right: 9, top: 15.0, bottom: 15),
                  child: Container(
                      width: double.infinity,

                      decoration: BoxDecorations.buildBoxDecoration_1(),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: i,
                            fit: BoxFit.fill,
                          ))),
                );
              },
            );
          }).toList(),
        ),
      );
    } else if (!_isCarouselInitial && _carouselImageList.length == 0) {
      return Container(
          height: 0,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 10,
      );
    }
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // Don't show the leading button
      backgroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      flexibleSpace: Padding(
        // padding:
        //     const EdgeInsets.only(top: 40.0, bottom: 22, left: 18, right: 18),
          padding:
          const EdgeInsets.only(top: 20.0, bottom: 22, left: 18, right: 18),
          child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Filter();
                }));
              },
              child: buildHomeSearchBox(context))),
    );
  }

  buildHomeSearchBox(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Search",
              // AppLocalizations.of(context)!.home_screen_search,
              style: TextStyle(fontSize: 13.0, color: MyTheme.textfield_grey),
            ),
            Image.asset(
              'assets/search.png',
              height: 16,
              //color: MyTheme.dark_grey,
              color: MyTheme.dark_grey,
            )
          ],
        ),
      ),
    );

  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showAllLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalAllProductData == _allProductList.length
            ? AppLocalizations.of(context)!.common_no_more_products
            : AppLocalizations.of(context)!.common_loading_more_products),
      ),
    );
  }
}
