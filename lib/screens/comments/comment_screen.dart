//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
//
// class AddressScreen extends StatefulWidget {
//   const AddressScreen({super.key});
//
//   @override
//   State<AddressScreen> createState() => _AddressScreenState();
// }
//
// class _AddressScreenState extends State<AddressScreen> {
//   final PagingController<int, Address> _pagingController =
//       PagingController(firstPageKey: 1);
//
//   Future<List<Address>> fetchData(int pageKey) async {
//     try {
//       final service = UserService();
//       final data = await service.fetchAddress(pageKey, true);
//       return data;
//     } catch (error) {
//       print('Error: $error');
//       rethrow;
//     }
//   }
//
//   @override
//   void initState() {
//     print("fetch address");
//     _pagingController.addPageRequestListener((pageKey) {
//       fetchData(pageKey).then((data) {
//         if (data.length < 15) {
//           _pagingController.appendLastPage(data);
//         } else {
//           _pagingController.appendPage(data, pageKey + 1);
//         }
//       }).catchError((error) {
//         _pagingController.error = error;
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     final bool isTablet = ScreenUtils.isTablet(context);
//     final double desiredItemWidth = isTablet ? 200.w : 400.w;
//     final double desiredItemHeight = isTablet ? 150.h : 160.h;
//     final int crossAxisCount =
//         (ScreenUtils.width(context) / desiredItemWidth).floor();
//     final double childAspectRatio = desiredItemWidth / desiredItemHeight;
//     return Scaffold(
//         appBar: MainAppBar(
//           title: "your_addresses".tr(),
//           specialAction: [
//             IconButton(
//               onPressed: () {
//                 pushNewScreenWithRouteSettings(
//                   context,
//                   settings: RouteSettings(name: '/add_edit_address'),
//                   screen: AddEditAddressScreen(),
//                   withNavBar: false,
//                   pageTransitionAnimation: PageTransitionAnimation.cupertino,
//                 );
//               },
//               iconSize: isTablet ? 20.sp : 30.sp,
//               icon: Icon(
//                 Icons.add,
//                 color: theme.primaryColor,
//               ),
//             ),
//             SizedBox(width: isTablet ? 5.w : null)
//           ],
//         ),
//         body: PagedGridView<int, Address>(
//           pagingController: _pagingController,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: crossAxisCount,
//             childAspectRatio: childAspectRatio,
//           ),
//           builderDelegate: PagedChildBuilderDelegate<Address>(
//             firstPageProgressIndicatorBuilder: (_) => Loading(),
//             newPageProgressIndicatorBuilder: (_) => Loading(),
//             noMoreItemsIndicatorBuilder: (_) => SizedBox.shrink(),
//             noItemsFoundIndicatorBuilder: (_) =>
//                 ErrorCard(errorType: "empty_list"),
//             firstPageErrorIndicatorBuilder: (_) => ErrorCard(
//               refresh: () => _pagingController.refresh(),
//               errorType: _pagingController.error.toString(),
//             ),
//             // newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
//             //   error: _pagingController.error,
//             //   onTryAgain: () => _pagingController.retryLastFailedRequest(),
//             // ),
//             itemBuilder: (context, address, index) {
//               return Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
//                 child: AddressCard(
//                   address: address,
//                   onTapEdit: () {
//                     if (address.type == Address.TEXT_ADDRESS) {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 AddEditAddressScreen(address: address),
//                           ));
//                     } else {
//                       pushNewScreenWithRouteSettings(
//                         context,
//                         settings: RouteSettings(name: '/location_selector'),
//                         screen: LocationSelectionScreen(address: address),
//                         withNavBar: false,
//                         pageTransitionAnimation:
//                             PageTransitionAnimation.cupertino,
//                       );
//                     }
//                   },
//                   onTapRemove: () {
//                     deleteAddress(address);
//                   },
//                 ),
//               );
//             },
//           ),
//         ));
//   }
//
//   void deleteAddress(Address address) async {
//     var response;
//     final bool isTablet = ScreenUtils.isTablet(context);
//     SnackBar success = SnackBar(
//         content: Text(
//           'Deleted address successful',
//           style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
//         ));
//     SnackBar failed = SnackBar(
//         content: Text(
//           'Deleted address failed',
//           style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
//         ));
//     try {
//       UserService service = UserService();
//       response = await service.deleteAddress(address);
//       // Check the response status code.
//       if (response.statusCode == 200) {
//         // Create address was successful.
//         ScaffoldMessenger.of(context).showSnackBar(success);
//         _pagingController.refresh();
//       } else {
//         // The failed.
//         ScaffoldMessenger.of(context).showSnackBar(failed);
//       }
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(failed);
//     }
//     return response;
//   }
// }
