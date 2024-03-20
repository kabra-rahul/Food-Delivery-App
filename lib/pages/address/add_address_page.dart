import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_appbar.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/pages/account/account_page.dart';
import 'package:food_delivery/pages/address/pick_address_page.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/user_controller.dart';


class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {

  TextEditingController _addressController   = TextEditingController();
  late final TextEditingController _contactPersonName   = TextEditingController();
  late final TextEditingController _contactPersonNumber = TextEditingController();
  late bool _isLogged;
  CameraPosition _cameraPosition = const CameraPosition(target: LatLng(45.51563, -122.677433),zoom: 17);
  late LatLng _initialPosition = const LatLng(45.51563, -122.677433);

  @override
  void initState() {
    super.initState();
    _isLogged = Get.find<AuthController>().userLoggedIn();
    if(_isLogged) {
      Get.find<UserController>().getUserInfo();
    }

    if(Get.find<LocationController>().addressList.isNotEmpty){

      if(Get.find<LocationController>().getUserAddressFromLocalStorage()=="") {
        Get.find<LocationController>().saveUserAddress(Get.find<LocationController>().addressList.last);
      }

      Get.find<LocationController>().getUserAddress();

      _cameraPosition = CameraPosition(target: LatLng(
        double.parse(Get.find<LocationController>().getAddress["latitude"]),
        double.parse(Get.find<LocationController>().getAddress["longitude"]),
      ));
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress["latitude"]),
        double.parse(Get.find<LocationController>().getAddress["longitude"]),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Address Page'),
      body: GetBuilder<UserController>(builder: (userController){
            if(_contactPersonName.text.isEmpty && userController.userModel!=null) {
              _contactPersonName.text = userController.userModel!.name;
              _contactPersonNumber.text = userController.userModel!.phone;

              if(Get.find<LocationController>().addressList.isNotEmpty) {
                _addressController.text = Get.find<LocationController>().getUserAddress().address;
              }
            }

        return GetBuilder<LocationController>(builder: (locationController){
          _addressController.text = '${locationController.placemark.name??''}'
              '${locationController.placemark.locality??''}'
              '${locationController.placemark.postalCode??''}'
              '${locationController.placemark.country??''}';

         // print("Address : ${_addressController.text}");
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 140 ,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 2,
                          color: AppColors.mainColor
                      )
                  ),
                  child: Stack(
                    children: [
                      GoogleMap(initialCameraPosition:
                      CameraPosition( target: _initialPosition, zoom: 17),
                        onTap: (latlng){
                           Get.toNamed(RouteHelper.getPickAddressPage(),
                           arguments: PickAddressPage(
                             fromSignUp: false,
                             fromAddressArea: true,
                             googleMapController: locationController.googleMapController,
                           ));
                        },
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: false,
                        myLocationEnabled: true,
                        onCameraIdle: (){
                          locationController.updatePosition(_cameraPosition,true);
                        },
                        onCameraMove: ((position)=>_cameraPosition=position),
                        onMapCreated: (GoogleMapController controller){
                          locationController.setMapController(controller);
                          if(Get.find<LocationController>().addressList.isEmpty) {

                          }
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.height20, top: Dimensions.height20),
                  child: SizedBox(height: Dimensions.height30*2,
                    child: ListView.builder(itemCount: locationController.addressTypeList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          locationController.setAddressType(index);
                        },
                        child: Container(
                          padding: EdgeInsets.all(Dimensions.height20),
                          margin: EdgeInsets.only(right: Dimensions.height10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.height10/2),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200]!,
                                spreadRadius: 1,
                                blurRadius: 5
                              )
                            ]
                          ),
                          child: Icon(index==0?Icons.home_filled:index==1?Icons.work:Icons.location_on ,
                              color: locationController.addressTypeIndex==index?AppColors.mainColor:Theme.of(context).disabledColor),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: Dimensions.height30),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.height20),
                  child: BigText(text: "Delivery Address"),
                ),
                SizedBox(height: Dimensions.height10),
                AppTextField(textEditingController: _addressController, hintText: "Delivery Address", icon: Icons.map),
                SizedBox(height: Dimensions.height30),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.height20),
                  child: BigText(text: "Customer Name"),
                ),
                SizedBox(height: Dimensions.height10),
                AppTextField(textEditingController: _contactPersonName, hintText: "Contact Name", icon: Icons.person),
                SizedBox(height: Dimensions.height30),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.height20),
                  child: BigText(text: "Customer Number"),
                ),
                SizedBox(height: Dimensions.height10),
                AppTextField(textEditingController: _contactPersonNumber, hintText: "Contact Number", icon: Icons.phone),
              ],
            ),
          );
        });
      }),
      bottomNavigationBar: GetBuilder<LocationController>(builder: (locationController){
        return  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Dimensions.height20*8,
              padding: EdgeInsets.all(Dimensions.height20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.height30),
                      topRight: Radius.circular(Dimensions.height30)
                  ),
                  color: AppColors.buttonBackgroundColor
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      AddressModel _addressModel = AddressModel(addressType: locationController.addressTypeList[locationController.addressTypeIndex],
                                                   address: _addressController.text,
                                                   contactPersonName: _contactPersonName.text,
                                                   contactPersonNumber: _contactPersonNumber.text,
                                                   latitude: locationController.position.latitude.toString(),
                                                   longitude: locationController.position.longitude.toString());

                      locationController.addAddress(_addressModel).then((response) {
                        if(response.isSuccess) {
                          Get.toNamed(RouteHelper.getInitialRoute());
                          Get.snackbar("Address", "Added Successfully");
                        } else {
                          Get.snackbar("Address", "Couldn't Save Address");
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        padding: EdgeInsets.all(Dimensions.height20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimensions.height20)
                        )
                    ),
                    child: BigText(text: 'Save Address',size: 26, color: Colors.white),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
