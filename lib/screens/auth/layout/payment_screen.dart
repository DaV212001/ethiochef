import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../main.dart';
import '../../../widgets/main_app_bar.dart';

class PaymentScreen extends StatefulWidget {
  final String url;
  const PaymentScreen({
    super.key,
    required this.url,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = true;
  bool error = false;
  String errorText = "";
  bool loadedAferError = false;
  bool isInitialLoadComplete = false; // Flag to prevent multiple executions
  Uri? previousUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: "",
        hasMainIcons: false,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(widget.url),
            ),
            onLoadStop: (controller, url) async {
              if (!isInitialLoadComplete) {
                setState(() {
                  isInitialLoadComplete = true;
                });
                print(
                    'CHAPAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, previous: $previousUrl');
                print(
                    '===================================LOAD START: ${url} weburi: ${Uri.parse('https://www.ethiochef.com/')}');
                if (url == Uri.parse('https://www.ethiochef.com/')) {
                  print('ETHIO CHEF REDIRECTION DETECTED');
                  // await Offer18Plugin.trackConversion(
                  //     Offer18EventArguments.REGISTRATION);
                  RestartWidget.restartApp(context);
                }
              }
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              controller.getCertificate();
              if (progress >= 100) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            // onReceivedError: (InAppWebViewController controller,
            //     WebResourceRequest request, WebResourceError err) {
            //   if (!loadedAferError) {
            //     print("ERRORRRRRRRRRRRRRRRR");
            //     controller.loadUrl(
            //       urlRequest: URLRequest(
            //         url: WebUri.uri(
            //           Uri.parse(widget.url),
            //         ),
            //       ),
            //     );
            //     setState(() {
            //       loadedAferError = true;
            //     });
            //   }
            // },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              // Log or analyze the URL being loaded
              String currentUrl = navigationAction.request.url.toString();
              String destinationUrl =
                  navigationAction.request.url.toString(); // Destination URL

              // Check if the current URL is different from the destination URL
              if (currentUrl != destinationUrl) {
                // This indicates a redirection
                // Log or analyze the redirection
                print(
                    '==============================================================REDIRECTED from $currentUrl to $destinationUrl=========================================================');
              }

              return NavigationActionPolicy.ALLOW;
            },
            onReceivedServerTrustAuthRequest:
                (InAppWebViewController controller,
                    URLAuthenticationChallenge challenge) async {
              SslError? sslCertificateError = SslError();
              sslCertificateError = challenge.protectionSpace.sslError;
              return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED);
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (error)
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Center(
                child: Text(errorText),
              ),
            )
        ],
      ),
    );
  }
}
