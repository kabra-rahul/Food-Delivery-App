import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_button.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/pages/address/widget/search_location_dialog_page.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../models/address_model.dart';
import '../../utils/dimensions.dart';


class PickAddressPage extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddressArea;
  final GoogleMapController? googleMapController;

  const PickAddressPage({Key? key,
    required this.fromSignUp,
    required this.fromAddressArea,
    this.googleMapController}) : super(key: key);

  @override
  State<PickAddressPage> createState() => _PickAddressPageState();
}

class _PickAddressPageState extends State<PickAddressPage> {

  late LatLng _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(Get.find<LocationController>().addressList.isEmpty) {
      _initialPosition = const LatLng(45.521563, -122.677433);
    }
    else {
      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress["latitude"]),
        double.parse(Get.find<LocationController>().getAddress["longitude"]),
      );
    }
    _cameraPosition =  CameraPosition(target: _initialPosition, zoom: 17);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController){
        return Scaffold(
          body: SafeArea(
              child: Center(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _initialPosition,
                          zoom: 17
                      ),
                        zoomControlsEnabled: false,
                        onCameraMove: (CameraPosition cameraPosition){
                          _cameraPosition=cameraPosition;
                        },
                        onCameraIdle: (){
                          locationController.updatePosition(_cameraPosition,false);
                        },
                        onMapCreated: (GoogleMapController mapController){
                          _mapController = mapController;
                          if(!widget.fromAddressArea){

                          }
                        },
                      ),
                      Center(
                        child:  !locationController.loading?Image.asset("assets/image/pick_marker.png",
                                 height: 50, width: 50,
                        ):const CustomLoader()
                      ),
                      Positioned(top: Dimensions.height45,
                        left: Dimensions.height15,
                        right: Dimensions.height15,
                        child: InkWell(
                          onTap: ()=>Get.dialog(LocationDialog(mapController: _mapController)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.height10, vertical: Dimensions.height10),
                            height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.height10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        spreadRadius: 7,
                                        offset: const Offset(1,10),
                                        color: Colors.grey.withOpacity(0.75)
                                    )
                                  ]
                              ),
                              child : Row(
                                children: [
                                  Icon(Icons.location_on, size: 25,color: AppColors.yellowColor),
                                  Expanded(
                                    child: Text(
                                       locationController.pickPlacemark.name??'',
                                       style: TextStyle(
                                         fontSize: Dimensions.font16,
                                       ),
                                       overflow: TextOverflow.ellipsis,
                                       maxLines: 1
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.height10/2),
                                  Icon(Icons.search_rounded, color: AppColors.yellowColor,size: 25,)
                                ],
                              )
                          ),
                        )
                      ),
                      Positioned(bottom: Dimensions.height45,
                        left: Dimensions.height20,
                        right: Dimensions.height20,
                        child: locationController.isLoading?const CustomLoader():CustomButton(
                          buttonText: locationController.inZone?widget.fromAddressArea?"Save Address":"Pick Location":"Service Not Available",
                          onPressed: (locationController.buttonDisable||locationController.loading)?null:(){
                            if(locationController.pickPosition.latitude!=0 &&
                                locationController.pickPlacemark.name != null) {
                              if(widget.fromAddressArea) {
                                if(widget.googleMapController != null){
                                  widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(
                                      CameraPosition(target: LatLng(
                                          locationController.pickPosition.latitude,
                                          locationController.pickPosition.longitude
                                      )
                                      )
                                  )
                                  );
                                  locationController.setAddAddressData();
                                  locationController.saveUserAddress(
                                    AddressModel(
                                      addressType: locationController.addressTypeList[locationController.addressTypeIndex],
                                      address: locationController.pickPlacemark.name,
                                      latitude: locationController.pickPosition.latitude.toString(),
                                      longitude: locationController.pickPosition.longitude.toString(),
                                    ),
                                  );
                                }
                                //Get.back();
                                Get.toNamed(RouteHelper.getAddAddressPage());
                              }
                            }
                          },
                        )
                      )
                    ],
                  ),
                ),
              )
          ),
        );
    });
  }
}
