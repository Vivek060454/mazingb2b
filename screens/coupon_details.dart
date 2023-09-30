import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../repositories/coupon_repository.dart';
import '../repositories/quickorder.dart';

class Coupondetails extends StatefulWidget {
  const Coupondetails({Key? key}) : super(key: key);

  @override
  State<Coupondetails> createState() => _CoupondetailsState();
}

class _CoupondetailsState extends State<Coupondetails> {

  List<dynamic> couponList = [];

  @override
  void initState() {
    couponlist();
    // TODO: implement initState
    super.initState();
  }



  couponlist() async {
      print('#####jrjfthgj####');
    var couponresponse= await CouponRepository().coupon();
    print(couponresponse);

    couponList=couponresponse.coupon;
     // couponList=couponresponse.coupon;

     print('#####jrgj####');
      print(couponList[0].code);
      setvariable();
      setState(() {   });
      print("######");


     }
      setvariable(){

      }


  @override
  Widget build(BuildContext context) {
    if(couponList.length==0){
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('No Coupon'),
      );
    }


                             if(couponList.length>0){
                               return Padding(
                                 padding: const EdgeInsets.only(top: 30),
                                 child: ListView.builder(

                                                   shrinkWrap: true,
                                                itemCount: couponList.length,
                                           itemBuilder: (context,index){

                                                     var codename=  couponList[index].code;
                                                     var description=  couponList[index].description;
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Card(

                                                 color:MyTheme.accent_color,
                                                child: Container(


                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(

                                                         children: [
                                                       Align(
                                                           alignment: Alignment.topLeft,
                                                           child: Text(codename,style: TextStyle(fontSize: 20,color:Colors.white,fontWeight: FontWeight.w600),)) ,
                                                                 SizedBox(
                                                                   height: 5,
                                                                 ) ,
                                                              Align(
                                                                  alignment: Alignment.topLeft,
                                                                  child: Text(description,style: TextStyle(color: Colors.white,),))
                                                            ],
                                                       ),
                                                  ),
                                                     ),
                                                    ),
                                            ) ;
                                                } ),
                               ) ;

                             }



    return Center(
      child: CircularProgressIndicator(),
    )                        ;


  }
}
