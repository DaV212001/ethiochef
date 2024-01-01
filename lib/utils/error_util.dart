import 'package:easy_localization/easy_localization.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../models/error_data.dart';

class ErrorUtil {
  static ErrorData internalServerError = ErrorData(
    title: "500_title".tr(),
    body: "500_body".tr(),
    image: "assets/images/errors/internal_server.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData serviceUnavailableError = ErrorData(
    title: "503_title".tr(),
    body: "503_body".tr(),
    image: "assets/images/errors/service_unavailable.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData notFoundError = ErrorData(
    title: "404_title".tr(),
    body: "404_body".tr(),
    image: "assets/images/errors/not_found.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData gatewayTimeOutError = ErrorData(
    title: "504_title".tr(),
    body: "504_body".tr(),
    image: "assets/images/errors/gateway_timeout.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData unauthorizedError = ErrorData(
    title: "401_title".tr(),
    body: "401_body".tr(),
    image: "assets/images/errors/unauthorized.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData forbiddenError = ErrorData(
    title: "403_title".tr(),
    body: "403_body".tr(),
    image: "assets/images/errors/forbidden.svg",
    buttonText: "Go Back",
  );
  static ErrorData tooManyRequestsError = ErrorData(
    title: "429_title".tr(),
    body: "429_body".tr(),
    image: "assets/images/errors/too_many_requests.svg",
    buttonText: "Retry",
  );
  static ErrorData emptyCategory = ErrorData(
    title: "empty_category".tr(),
    body: "empty_category_body".tr(),
    image: "assets/images/errors/empty_list.svg",
  );
  static ErrorData emptySubCategory = ErrorData(
    title: "empty_sub_category".tr(),
    body: "empty_sub_category".tr(),
    image: "assets/images/errors/empty_list.svg",
    buttonText: "refresh".tr()
  );
  static ErrorData emptyFood = ErrorData(
    title: "empty_food".tr(),
    body: "no_food_in_this_category".tr(),
    image: "assets/images/errors/empty_food.svg"
  );
  static ErrorData emptySearchListError = ErrorData(
    title: "empty_search_list_title".tr(),
    body: "empty_search_list_body".tr(),
    image: "assets/images/errors/empty_list.svg"
  );
  static ErrorData emptySearchQueryError = ErrorData(
    title: "empty_search_query_title".tr(),
    body: "",
    image: "assets/images/errors/empty_search_query.svg"
  );
  static ErrorData noConnectionError = ErrorData(
    title: "no_connection".tr(),
    body: "no_connection_text".tr(),
    image: "assets/images/errors/no_connection.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData unknownError = ErrorData(
    title: "unknown_title".tr(),
    body: "unknown_body".tr(),
    image: "assets/images/errors/unknown.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData uploadingVideo = ErrorData(
    title: "uploading_title".tr(),
    body: "uploading_body".tr(),
    image: "",
    buttonText: "cancel".tr(),
  );

  static ErrorData getErrorType(String type) {
    print("Error type for error card $type");
    type = removeExceptionPrefix(type);
    switch (type) {
      case "500":
        return internalServerError;
      case "503":
        return serviceUnavailableError;
      case "404":
        return notFoundError;
      case "504":
        return gatewayTimeOutError;
      case "401":
        return unauthorizedError;
      case "403":
        return forbiddenError;
      case "429":
        return tooManyRequestsError;
      case "uploading_video":
        return uploadingVideo;
      case "empty_category":
        return emptyCategory;
      case "empty_sub_category":
        return emptySubCategory;
      case "no_food_in_this_category":
        return emptyFood;
      case "empty_search_list":
        return emptySearchListError;
      case "empty_search_query":
        return emptySearchQueryError;
      case "no_internet":
        return noConnectionError;
      default:
        return unknownError;
    }
  }

  static String removeExceptionPrefix(String errorMessage) {
    const exceptionPrefix = 'Exception: ';
    if (errorMessage.startsWith(exceptionPrefix)) {
      return errorMessage.substring(exceptionPrefix.length);
    }
    return errorMessage;
  }

  static Future<void> checkConnection() async{
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    try{
      if(!isConnected){
        throw Exception("no_internet");
      }
    } catch(error){
      print(error);
      rethrow;
    }

  }
}