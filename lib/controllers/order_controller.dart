import 'package:food_delivery/data/repository/order_repo.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:food_delivery/models/place_order_model.dart';
import 'package:get/get.dart';

class OrderController extends GetxController implements GetxService {
  OrderRepo orderRepo;

  OrderController({required this.orderRepo});

  bool _isLoading = false;
  late List<OrderModel> _currentOrderList;
  late List<OrderModel> _historyOrderList;
  int _isOptionSelected = 0;
  String _deliveryOption = 'Home Delivery';
  String _foodNote = "";

  bool get isLoading => _isLoading;
  List<OrderModel> get currentOrderList => _currentOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;
  int get isOptionSelected => _isOptionSelected;
  String get deliveryOption => _deliveryOption;
  String get foodNote => _foodNote;

  Future<void> placeOrder(Function callback, PlaceOrderBody orderDetail) async {
    _isLoading = true;

    Response response = await orderRepo.placeOrder(orderDetail);

    if(response.statusCode == 200) {
      _isLoading = false;
      String message = response.body['message'];
      String orderId = response.body['order_id'].toString();
      callback(true,message,orderId);
    } else {
      //print(response.body);
      callback(false, response.statusText ,'-1');
    }
  }


  Future<void> getOrderList() async {
    _isLoading = true;
    //update();
    Response response = await orderRepo.getOrderList();

    if(response.statusCode == 200) {
      _currentOrderList = [];
      _historyOrderList = [];
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);

        if(orderModel.orderStatus == 'pending' ||
           orderModel.orderStatus == 'accepted' ||
           orderModel.orderStatus == 'processing' ||
           orderModel.orderStatus == 'handover' ||
           orderModel.orderStatus == 'picked_up' ) {
              _currentOrderList.add(orderModel);
        } else {
              _historyOrderList.add(orderModel);
        }
      });
    } else {
      _currentOrderList = [];
      _historyOrderList = [];
    }
    _isLoading = false;
    update();
}


void updatePaymentOption(int indexValue) {
    _isOptionSelected = indexValue;
    update();
}


void updateDeliveryOption(String value) {
    _deliveryOption = value;
    update();
}

void updateFoodNote(String note) {
  _foodNote = note;
  update();
}

}