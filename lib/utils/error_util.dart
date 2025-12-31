import 'package:easy_localization/easy_localization.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../models/error_data.dart';
import '../models/language.dart';

enum ApiCallStatus {
  loading,
  success,
  error,
  empty,
  holding,
  cache,
  refresh,
}

class ErrorUtil {
  static ErrorData comingSoon = ErrorData(
    title: "coming_soon".tr(),
    body: "".tr(),
    image: "assets/images/errors/empty_food.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Coming soon"
        : Language.getLocaleCode() == "am"
            ? "በቅርቡ ይመጣል"
            : Language.getLocaleCode() == "or"
                ? "Yeroo dhiyootti"
                : Language.getLocaleCode() == "ti"
                    ? "ኣብዚ ቐረባ እዋን"
                    : "Dhawaan imaanaya",
  );

  static ErrorData internalServerError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/unknown.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData serviceUnavailableError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/unknown.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData notFoundError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/no_connection.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData gatewayTimeOutError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/no_connection.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData unauthorizedError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/unknown.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData forbiddenError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/unknown.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData tooManyRequestsError = ErrorData(
    title: "".tr(),
    body: "".tr(),
    image: "assets/images/errors/no_connection.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData emptyCategory = ErrorData(
    title: "empty_category".tr(),
    body: "empty_category_body".tr(),
    image: "assets/images/errors/empty_list.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData emptySubCategory = ErrorData(
    title: "empty_sub_category".tr(),
    body: "empty_sub_category".tr(),
    image: "assets/images/errors/empty_list.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData emptyFood = ErrorData(
      title: "empty_food".tr(),
      body: "no_food_in_this_category".tr(),
      image: "assets/images/errors/empty_food.svg");
  static ErrorData emptySearchListError = ErrorData(
      title: "empty_search_list_title".tr(),
      body: "empty_search_list_body".tr(),
      image: "assets/images/errors/empty_list.svg");
  static ErrorData emptySearchQueryError = ErrorData(
      title: "".tr(),
      body: "",
      image: "assets/images/errors/empty_search_query.svg");
  static ErrorData noConnectionError = ErrorData(
    title: "no_connection".tr(),
    body: "no_connection_text".tr(),
    image: "assets/images/errors/no_connection.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData unknownError = ErrorData(
    title: "assets/images/errors/no_connection.svg".tr(),
    body: "".tr(),
    image: "assets/images/errors/unknown.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );
  static ErrorData uploadingVideo = ErrorData(
    title: "".tr(),
    body: "",
    image: "assets/images/errors/no_connection.svg",
    buttonText: Language.getLocaleCode() == "en"
        ? "Refresh"
        : Language.getLocaleCode() == "am"
            ? "እንደገና ይሞክሩ"
            : Language.getLocaleCode() == "or"
                ? "Haaromsi"
                : Language.getLocaleCode() == "ti"
                    ? "ምሕዳስ"
                    : "Dib u cusboonaysii",
  );

  static ErrorData getErrorType(String type) {
    print("Error type for error card $type, lang: ${Language.getLocaleCode()}");
    ErrorData comingSoon = ErrorData(
      title: "coming_soon".tr(),
      body: "".tr(),
      image: "assets/images/errors/empty_food.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Coming soon"
          : Language.getLocaleCode() == "am"
              ? "በቅርቡ ይመጣል"
              : Language.getLocaleCode() == "or"
                  ? "Yeroo dhiyootti"
                  : Language.getLocaleCode() == "ti"
                      ? "ኣብዚ ቐረባ እዋን"
                      : "Dhawaan imaanaya",
    );

    ErrorData internalServerError = ErrorData(
      title: "".tr(),
      body: "".tr(),
      image: "assets/images/errors/unknown.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData serviceUnavailableError = ErrorData(
      title: "".tr(),
      body: "".tr(),
      image: "assets/images/errors/unknown.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData notFoundError = ErrorData(
      title: "".tr(),
      body: "".tr(),
      image: "assets/images/errors/no_connection.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData gatewayTimeOutError = ErrorData(
      title: "".tr(),
      body: "".tr(),
      image: "assets/images/errors/no_connection.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData unauthorizedError = ErrorData(
      title: "".tr(),
      body: "".tr(),
      image: "assets/images/errors/unknown.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData forbiddenError = ErrorData(
      title: "".tr(),
      body: "".tr(),
      image: "assets/images/errors/unknown.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData tooManyRequestsError = ErrorData(
      title: "".tr(),
      body: "".tr(),
      image: "assets/images/errors/no_connection.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData emptyCategory = ErrorData(
      title: "empty_category".tr(),
      body: "empty_category_body".tr(),
      image: "assets/images/errors/empty_list.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData emptySubCategory = ErrorData(
      title: "empty_sub_category".tr(),
      body: "empty_sub_category".tr(),
      image: "assets/images/errors/empty_list.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData emptyFood = ErrorData(
        title: "empty_food".tr(),
        body: "no_food_in_this_category".tr(),
        image: "assets/images/errors/empty_food.svg");
    ErrorData emptySearchListError = ErrorData(
        title: "empty_search_list_title".tr(),
        body: "empty_search_list_body".tr(),
        image: "assets/images/errors/empty_list.svg");
    ErrorData emptySearchQueryError = ErrorData(
        title: "".tr(),
        body: "",
        image: "assets/images/errors/empty_search_query.svg");
    ErrorData noConnectionError = ErrorData(
      title: "no_connection".tr(),
      body: "no_connection_text".tr(),
      image: "assets/images/errors/no_connection.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData unknownError = ErrorData(
      title: "assets/images/errors/no_connection.svg".tr(),
      body: "".tr(),
      image: "assets/images/errors/unknown.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
    ErrorData uploadingVideo = ErrorData(
      title: "".tr(),
      body: "",
      image: "assets/images/errors/no_connection.svg",
      buttonText: Language.getLocaleCode() == "en"
          ? "Refresh"
          : Language.getLocaleCode() == "am"
              ? "እንደገና ይሞክሩ"
              : Language.getLocaleCode() == "or"
                  ? "Haaromsi"
                  : Language.getLocaleCode() == "ti"
                      ? "ምሕዳስ"
                      : "Dib u cusboonaysii",
    );
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
      case "coming_soon":
        return ErrorData(
          title: "coming_soon".tr(),
          body: "".tr(),
          image: "assets/images/errors/empty_food.svg",
          buttonText: Language.getLocaleCode() == "en"
              ? "Coming soon"
              : Language.getLocaleCode() == "am"
                  ? "በቅርቡ ይመጣል"
                  : Language.getLocaleCode() == "or"
                      ? "Yeroo dhiyootti"
                      : Language.getLocaleCode() == "ti"
                          ? "ኣብዚ ቐረባ እዋን"
                          : "Dhawaan imaanaya",
        );
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

  static Future<void> checkConnection() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    try {
      if (!isConnected) {
        throw Exception("no_internet");
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
