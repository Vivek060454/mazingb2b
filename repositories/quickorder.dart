import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/addons_response.dart';
import 'package:active_ecommerce_flutter/repositories/prodyct_quickorder.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import '../data_model/coupon_model.dart';
import '../data_model/product_mini_response.dart';
import '../data_model/quick_categopry_group.dart';
import '../data_model/quickorder_brandlist.dart';
import '../data_model/quickorder_categorielist.dart';
import '../helpers/shared_value_helper.dart';

class QuickOrderRepository{
  final  storage = new LocalStorage('key');


  Future<CategoriesGroupResponse> getCategoriesGroup() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/quick-order/category-groups");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return categoriesGroupResponseFromJson(response.body);
  }


  Future<ProductQuickOrderResponse> getProductList({int ?category_group_id, List ?categories, List ?brands,page}) async {
    // Uri url = Uri.parse("${AppConfig.BASE_URL}/products/quick-order?category_group_id=${[3]}&categories[=${[2]}&brands=${[2]}");
    Uri url;
if(storage.getItem('warehouseid')!=null){
  url = Uri.parse("${AppConfig.BASE_URL}/products/quick-order?page=${page}?user_warehouse_id=${storage.getItem('warehouseid')}&category_group_id=${category_group_id==null?'':category_group_id}&brands=${brands!.length==0?'':brands.join(',').toString()}&categories=${categories!.length==0?'':categories.join(',').toString()}");

}
else{
  url = Uri.parse("${AppConfig.BASE_URL}/products/quick-order?page=${page}?category_group_id=${category_group_id==null?'':category_group_id}&brands=${brands!.length==0?'':brands.join(',').toString()}&categories=${categories!.length==0?'':categories.join(',').toString()}");

}


print('fjhsf'+url.toString());
    print(category_group_id.toString()+'kjfgkhjnjjbg'+categories.toString()+'jhghkjhju'+brands.join(',').toString());

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productQuickOrderResponseFromJson(response.body);
  }
  Future<CategoriesListQuickOrderResponse> getCategorieslist(grouotype) async {
    Uri url;

       url = Uri.parse("${AppConfig.BASE_URL}/products/quick-order/categories?category_group_id=${grouotype==null?'':grouotype}");


print('###########$url');
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return categoriesListQuickOrderResponseFromJson(response.body);
  }
  Future<BrandListQuickOrderResponse> getBrandlist(grouotype) async {
    Uri url;

       url = Uri.parse("${AppConfig.BASE_URL}/products/quick-order/brands?category_group_id=${grouotype==null?'':grouotype}");


    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return brandListQuickOrderResponseFromJson(response.body);
  }
}