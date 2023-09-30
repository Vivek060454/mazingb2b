import 'package:active_ecommerce_flutter/custom/common_functions.dart';
import 'package:active_ecommerce_flutter/data_model/proffesion.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/repositories/group_categories.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
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

import '../data_model/FeaturedCategories.dart';
import '../data_model/address_response.dart';
import '../data_model/brand.dart';
import '../data_model/group_categories.dart';
import '../data_model/message_response.dart';
import '../data_model/newproducts.dart';

class FeaturedCategoriesAllList extends StatefulWidget {

  FeaturedCategoriesAllList({required Key key, this.title, this.show_back_button = false, go_back = true, this.counter})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final CartCounter ?counter;

  final String? title;
  bool show_back_button;
  bool? go_back;

  @override
  _FeaturedCategoriesAllListState createState() => _FeaturedCategoriesAllListState();
}

class _FeaturedCategoriesAllListState extends State<FeaturedCategoriesAllList> with TickerProviderStateMixin {

  int _current_slider = 0;
  ScrollController ?_allProductScrollController;
  ScrollController? _featuredCategoryScrollController;
  ScrollController _mainScrollController = ScrollController();

  late AnimationController pirated_logo_controller;
  Animation ?pirated_logo_animation;

  var _carouselImageList = [];
  var _bannerOneImageList = [];
  var _bannerTwoImageList = [];
  var _featuredCategoryList = [];
  var _getCategories=[];
  Network network=Network();
  List <Group> userdata=[];
  List <Newproduct> newproductdata=[];
  List <Brande> branddata=[];
  List <Proffesion> proffesiondata=[];
  bool _isCategoryInitial = true;
  bool _getCategoriesInitial=true;
  bool _isCarouselInitial = true;
  bool _isBannerOneInitial = true;
  bool _isBannerTwoInitial = true;

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
  FeaturedCategoriesList? categoriesdata;
  List fe=[];
  int _cartCount = 0;

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
        //fetchAllProducts();
      }
    });
  }

  getCartCount() {
    Provider.of<CartCounter>(context, listen: false).getCount();
    //var res = await CartRepository().getCartCount();
    //widget.counter.controller.sink.add(res.count);
  }


  getData()async{

    categoriesdata=await network.categoriesfeature();
    fe =categoriesdata!.data;
    print(categoriesdata);
  }

  fetchAll() {


    getData();

  }
  fetchFeaturedCategories() async {
    var categoryResponse = await CategoryRepository().getFeturedCategories();
    _featuredCategoryList.addAll(categoryResponse.categories!);
    _isCategoryInitial = false;
    setState(() {});
  }


  reset() {
    _carouselImageList.clear();
    _bannerOneImageList.clear();
    _bannerTwoImageList.clear();
    _featuredCategoryList.clear();
    _getCategories.clear();
    _getCategoriesInitial=true;
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

    pirated_logo_controller!.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        pirated_logo_controller!.repeat();
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
             // key: _scaffoldKey,
              appBar:
             AppBar(
               title: Text('Featured Categories')
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
                                                pirated_logo_animation!
                                                    .value,
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

                          ]),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                18.0,
                                20.0,
                                18.0,
                                0.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   AppLocalizations.of(context)
                                  //       .home_screen_featured_categories,
                                  //   style: TextStyle(
                                  //       fontSize: 18,
                                  //       fontWeight: FontWeight.w700),
                                  // ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(

                                child: buildHomeFeaturedCategories(context),
                              ),

                            ],
                          ),

                        ),


                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: buildProductLoadingContainer())
                ],
              )),
        ),
      ),
    );
  }


  Widget  buildHomeFeaturedCategories(context) {
    if (fe.length == 0) {
      return ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
          crossAxisSpacing: 14.0,
          mainAxisSpacing: 14.0,
          item_count: fe.length,
          mainAxisExtent: 170.0,
          controller: _featuredCategoryScrollController);
    } else if (fe.length > 0) {
      //snapshot.hasData
      return GridView.builder(
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
            return GestureDetector(
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
                  decoration: BoxDecorations.buildBoxDecoration_1(),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.blue,
                          child: ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(6), right: Radius.zero),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: fe[index].banner,width: 80 ,height: 80,
                                fit: BoxFit.cover,
                              ))),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            fe[index].name,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            softWrap: true,
                            style:
                            TextStyle(fontSize: 12, color: MyTheme.font_grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    } else if (fe.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text('No category found',
                // AppLocalizations.of(context)!.home_screen_no_category_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }





  Container buildProductLoadingContainer() {
    return Container(
      height: _showAllLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalAllProductData == _allProductList.length
            ? 'No more product'
        // AppLocalizations.of(context)!.common_no_more_products
            : 'Loading more product'
        // AppLocalizations.of(context)!.common_loading_more_products
        ),
      ),
    );
  }
}
