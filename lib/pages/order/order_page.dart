import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_appbar.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/order_controller.dart';
import 'package:food_delivery/pages/order/view_order.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin{

  late TabController _tabController;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().userLoggedIn();
    if(_isLoggedIn) {
      _tabController = TabController(length: 2, vsync: this);
      Get.find<OrderController>().getOrderList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Orders', backButtonExist: false),
      body: Column(
        children: [
          Container(
            width: Dimensions.screenWidth,
            child: TabBar(
              indicatorColor: AppColors.mainColor,
              indicatorWeight: 3,
              labelColor: AppColors.mainColor,
              unselectedLabelColor: Theme.of(context).disabledColor,
              controller: _tabController,
              tabs: const [
                Tab(text: "Running"),
                Tab(text: "History",)
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: const [
                  ViewOrder(isCurrent: true),
                  ViewOrder(isCurrent: false)
                ]),
          )
        ],
      )
    );
  }
}

