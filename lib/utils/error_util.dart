import 'package:easy_localization/easy_localization.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../models/error_data.dart';

class ErrorUtil {
  static ErrorData internalServerError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/unknown.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData serviceUnavailableError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/unknown.svg",
      buttonText: "refresh".tr(),
  );
  static ErrorData notFoundError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/no_connection.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData gatewayTimeOutError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/no_connection.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData unauthorizedError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/unknown.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData forbiddenError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/unknown.svg",
    buttonText: "refresh".tr()
  );
  static ErrorData tooManyRequestsError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/no_connection.svg",
    buttonText: "refresh".tr(),
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
    title: "".tr(),
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
    title: "assets/images/errors/no_connection.svg".tr(),
    body: "".tr(),
    image: "assets/images/errors/unknown.svg",
    buttonText: "refresh".tr(),
  );
  static ErrorData uploadingVideo = ErrorData(
    title: "".tr(),
    body: "",
    image: "assets/images/errors/no_connection.svg",
    buttonText: "refresh".tr(),
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