// import 'dart:convert';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
//
// import '../../services/payment_service.dart';
//
// class SubscriptionStepper extends StatefulWidget {
//   const SubscriptionStepper({super.key});
//
//   @override
//   State<SubscriptionStepper> createState() => _SubscriptionStepperState();
// }
//
// class _SubscriptionStepperState extends State<SubscriptionStepper> {
//   Address? addressSelected;
//   Payment? paymentSelected;
//   int activeStep = 0;
//   bool awaitResponse = false;
//   bool showBackButton = true;
//   bool isPaymentSuccessful = true;
//   Future? _future;
//   String url = "";
//
//   Future<dynamic> fetchData() async {
//     try {
//       final addressService = UserService();
//       final addressData = await addressService.fetchAddress(0, true);
//       final paymentService = PaymentService();
//       final paymentData = await paymentService.fetchPayment();
//       return [addressData, paymentData];
//     } catch (error) {
//       print('Error: $error');
//       rethrow;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _future = fetchData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: MainAppBar(
//           title: 'checkout'.tr(),
//           hasMainIcons: false,
//         ),
//         body: SafeArea(
//             child: FutureBuilder(
//               future: _future,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Loading();
//                 }
//                 if (snapshot.hasError) {
//                   return Center(
//                       child: ErrorCard(
//                         errorType: snapshot.error.toString(),
//                         refresh: () {
//                           setState(() {
//                             _future = fetchData();
//                           });
//                         },
//                       ));
//                 }
//                 return buildScreen(snapshot.data[0] as List<Address>, snapshot.data[1] as List<Payment>);
//               },
//             )));
//   }
//
//   Widget buildScreen(List<Address> addresses, List<Payment> payment) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 15.w),
//         child: Column(
//           children: [
//             StepsHeader(activeStep: activeStep),
//             Visibility(
//               visible: activeStep == 0,
//               child: AddressStep(
//                 addresses: addresses,
//                 updateAddress: (address) {
//                   setState(() {
//                     addressSelected = address;
//                   });
//                 },
//                 refresh: () {
//                   setState(() {
//                     _future = fetchData();
//                   });
//                 },
//               ),
//             ),
//             // TODO IF WALLET IS CREATED THEN ADD IT HERE WITH THE ChoosePaymentStep
//             Visibility(
//               visible: activeStep == 1,
//               child: ChoosePaymentStep(
//                 payment: payment,
//                 refresh: () {
//                   setState(() {
//                     _future = fetchData();
//                   });
//                 },
//                 updatePayment: (payment) {
//                   setState(() {
//                     paymentSelected = payment;
//                     print("payment");
//                     print(payment?.id);
//                     print(payment?.name);
//                     print("paymentSelected");
//                     print(paymentSelected?.id);
//                     print(paymentSelected?.name);
//                   });
//                 },
//               ),
//             ),
//             Visibility(
//               visible: activeStep == 2,
//               child: OrderSummaryStep(addressSelected: addressSelected, paymentSelected: paymentSelected),
//             ),
//
//             StepperControlButtons(
//                 showBackButton: showBackButton,
//                 awaitResponse: awaitResponse,
//                 next: incrementStep,
//                 back: decrementStep,
//                 index: activeStep)
//           ],
//         ),
//       ),
//     );
//   }
//   Future<void> incrementStep() async {
//     if (activeStep == 0 && addressSelected == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('please_select_an_address'.tr())),
//       );
//       return;
//     }
//     if (activeStep == 1 && paymentSelected == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('please_select_a_payment_method'.tr())),
//       );
//       return;
//     }
//     if (activeStep == 2) {
//       bool createOrder = await composeAndSendMyOrder();
//       if (createOrder) {
//         await pushNewScreen(
//           context,
//           screen: PaymentScreen(url: url),
//           pageTransitionAnimation: PageTransitionAnimation.cupertino,
//         );
//         Navigator.of(context).popUntil((route) {
//           return route.settings.name == '/checkout';
//         });
//         Navigator.of(context).pop();
//       }
//
//     }
//     if(activeStep!=2){
//       setState(() {
//         activeStep++;
//       });
//     }
//   }
//
//   void decrementStep() {
//     if (activeStep == 1) {
//       addressSelected = null;
//     }
//     if (activeStep == 2) {
//       paymentSelected = null;
//     }
//     setState(() {
//       activeStep--;
//     });
//   }
//
//   Future<dynamic> getQuantity(List<int> itemVariationIds) async {
//     try {
//       var response = await Cart.checkQuantity(itemVariationIds);
//       List<dynamic> responseData = jsonDecode(response.body)["data"];
//       var result = responseData.cast<int>().toList();
//
//       print("Response checkQuantity: $result");
//       return result;
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Future<bool> composeAndSendMyOrder() async {
//     setState(() {
//       awaitResponse = true;
//       showBackButton = false;
//     });
//     final bool isTablet = ScreenUtils.isTablet(context);
//     SnackBar failed = SnackBar(
//         content: Text(
//           "order_was_created".tr(),
//           style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
//         ));
//     Map<String, dynamic> orderData = await Cart.composeOrder(addressSelected!, paymentSelected!);
//     List<int> itemVariationIds = Cart.getItemVariationIds(orderData);
//
//     try {
//       UserService service = UserService();
//       List<int> quantityResponse = await getQuantity(itemVariationIds);
//       List<Map<String, dynamic>> excessOrders =
//       Cart.checkQuantities(quantityResponse, orderData);
//
//       if (excessOrders.length > 0) {
//         setState(() {
//           awaitResponse = false;
//           showBackButton = true;
//         });
//         print("excessOrders $excessOrders");
//         await showDialog(
//           context: context,
//           builder: (context) {
//             return WillPopScope(
//               onWillPop: () async {
//                 if (true) {}
//                 return true;
//               },
//               child: Dialog(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.r),
//                 ),
//                 backgroundColor: Theme.of(context).cardColor,
//                 child: AlertQuantity(
//                     quantityResponse: quantityResponse,
//                     excessOrders: excessOrders),
//               ),
//             );
//           },
//         );
//         Navigator.of(context).pop();
//       }
//
//       print("excessOrders $excessOrders");
//       var response = await service.sendOrder(orderData);
//       print("status code ${response.statusCode}");
//       if (response.statusCode == 200) {
//         setState(() {
//           awaitResponse = false;
//           // TODO THE PAYMENT JSON BODY MIGHT CHANGE SO HEADS UP HERE
//           if(jsonDecode(response.body)["payment"]["data"]["checkout_url"] != null){
//             url = jsonDecode(response.body)["payment"]["data"]["checkout_url"];
//           }
//           Cart.clearCart();
//         });
//         if(jsonDecode(response.body)["payment"]["data"]["checkout_url"] != null){
//           return true;
//         }
//         return false;
//       } else {
//         setState(() {
//           awaitResponse = false;
//           showBackButton = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(failed);
//         return false;
//       }
//     } catch (e) {
//       print(e);
//       setState(() {
//         awaitResponse = false;
//         showBackButton = true;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(failed);
//       return false;
//     }
//   }
// }
