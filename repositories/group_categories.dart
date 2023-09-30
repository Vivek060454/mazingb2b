import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/discount.dart';
import 'package:toast/toast.dart';


import '../app_config.dart';

import '../data_model/FeaturedCategories.dart';
import '../data_model/best_seller.dart';
import '../data_model/brand.dart';
import '../data_model/group_categories.dart';
import 'package:http/http.dart' as http;

import '../data_model/newproducts.dart';
import '../data_model/proffesion.dart';
class Network{
  Future<Group> userData()async{

    final url=Uri.parse('${AppConfig.BASE_URL}/categories/home');
    final responce=await http.get(url);
    print(responce.body);
    return groupFromJson(responce.body);
  }
  // Future<BestSelling>bestSellingdata()async{
  //
  //   final url=Uri.parse('${AppConfig.BASE_URL}/products/best-seller');
  //   final responce=await http.get(url);
  //   print(responce.body);
  //   return bestSellingFromJson(responce.body);
  //
  //
  //
  // }
  Future<Newproduct> newproduct()async{

    final url=Uri.parse('${AppConfig.BASE_URL}/products/new');
    final responce=await http.get(url);

    return newproductFromJson(responce.body);



  }
  Future<Brande> brande()async{

    final url=Uri.parse('${AppConfig.BASE_URL}/brands');
    final responce=await http.get(url);
    print(responce.body);
    return brandeFromJson(responce.body);



  }
  Future<Proffesion> professiuon()async{

    final url=Uri.parse('${AppConfig.BASE_URL}/professions');
    final responce=await http.get(url);
    print(responce.body);
    return proffesionFromJson(responce.body);


  }
  postData({ String? name,String ?phone,String? product})async{
    final url=Uri.parse('${AppConfig.BASE_URL}/products/looking-for-product');
    final data={
      'product':product,
      'name':name,
      'contact':phone


    };
    final responce=await http.post(url,body:data);
    if(responce.statusCode==200){
      var d= jsonDecode( responce.body)['message'];
      if(d is String){
        Toast.show( d,
            duration: Toast.lengthLong, gravity: Toast.center);

        // Fluttertoast.showToast(msg: d);
      }
      else{
        d.forEach((key,value){
          if(value is String){
            print(value.toString());
            Toast.show((key+':'+value).toString(),
                duration: Toast.lengthLong, gravity: Toast.center);
            // Fluttertoast.showToast(msg:(key+':'+value).toString());

          }

          else{
            print(value.join(','));
            Toast.show((key.toString()+':'+value.join(',').toString()).toString(),
                duration: Toast.lengthLong, gravity: Toast.center);

            // Fluttertoast.showToast(msg:(key.toString()+':'+value.join(',').toString()).toString());

          }

        });
      }
      print('done');
      print(name!+phone!+product!);
    }
    else{
      var d= jsonDecode( responce.body)['message'];
      if(d is String){
        Toast.show( d,
            duration: Toast.lengthLong, gravity: Toast.center);

        // Fluttertoast.showToast(msg: d);
      }
      else{
        d.forEach((key,value){
          if(value is String){
            print(value.toString());
            Toast.show( (key+':'+value).toString(),
                duration: Toast.lengthLong, gravity: Toast.center);

            // Fluttertoast.showToast(msg:(key+':'+value).toString());

          }

          else{
            print(value.join(','));
            Toast.show( (key.toString()+':'+value.join(',').toString()).toString(),
                duration: Toast.lengthLong, gravity: Toast.center);

            // Fluttertoast.showToast(msg:(key.toString()+':'+value.join(',').toString()).toString());

          }

        });
      }
    }
  }
  Future<FeaturedCategoriesList> categoriesfeature()async{

    final url=Uri.parse('${AppConfig.BASE_URL}/categories/featured');
    final responce=await http.get(url);
    print(responce.body);
    return featuredCategoriesListFromJson(responce.body);



  }
  Future<BestsellerModel> bestseller()async{

    final url=Uri.parse('${AppConfig.BASE_URL}/products/best-seller');
    final responce=await http.get(url);
    print(responce.body);
    return bestsellerModelFromJson(responce.body);



  }

  Future<Discountei> discount() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/banners-three");

    final response=await http.get(url);
    return discountFromJson(response.body);
  }
}