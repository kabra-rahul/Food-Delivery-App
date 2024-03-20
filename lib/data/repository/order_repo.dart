import 'package:food_delivery/models/place_order_model.dart';
import 'package:get/get.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class OrderRepo {
  final ApiClient apiClient;

  OrderRepo({required this.apiClient});

  Future<Response> placeOrder(PlaceOrderBody orderDetail) async {
    return await apiClient.postData(AppConstants.PLACE_ORDER_URI,orderDetail.toJson());
  }

  Future<Response> getOrderList() async {
    return await apiClient.getData(AppConstants.ORDER_LIST_URI);
  }
}