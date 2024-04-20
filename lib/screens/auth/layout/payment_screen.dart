import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../widgets/main_app_bar.dart';

class PaymentScreen extends StatefulWidget {
  final String url;
  const PaymentScreen({super.key, required this.url, });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading=true;
  bool error = false;
  String errorText = "";
  bool loadedAferError = false;

WebUri? previousUrl;
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
                url: WebUri.uri(Uri.parse(widget.url),
                ),
            ),
            onLoadStop: (controller, url) {
              if(widget.url.contains('chapa')){
              // Handle URL changes here
              print('===================================LOAD START: $url');
              if (previousUrl != null && previousUrl != url) {
                print('===================================REDIRECT: $url from $previousUrl=================================');
                // Execute Flutter code upon redirection to the original checkout page
                if (url == WebUri.uri(Uri.parse(widget.url))) {
                  print('================================Redirected to Homeeeeeeeeeeeeeeeeeeeeeeeeeeeee: ${widget.url} ======= ${url?.path}');
                  Navigator.pop(context);
                }
              }
              // Update the previous URL
              setState(() {
                previousUrl = url;
              });
              }
            },
          onProgressChanged: (InAppWebViewController controller, int progress) {
              controller.getCertificate();
              if(progress>=100){
                setState(() {
                  isLoading = false;
                });
              }
          },
            onReceivedError:(InAppWebViewController controller, WebResourceRequest request, WebResourceError err) {
              if(!loadedAferError){
                print("ERRORRRRRRRRRRRRRRRR");
                controller.loadUrl(urlRequest: URLRequest(
                  url: WebUri.uri(Uri.parse(widget.url),
                  ),
                ),);
                setState(() {
                  loadedAferError = true;
                });
              }

            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              // Log or analyze the URL being loaded
              String currentUrl = navigationAction.request.url.toString();
              String destinationUrl = navigationAction.request.url.toString(); // Destination URL

              // Check if the current URL is different from the destination URL
              if (currentUrl != destinationUrl) {
                // This indicates a redirection
                // Log or analyze the redirection
                print('==============================================================REDIRECTED from $currentUrl to $destinationUrl=========================================================');
              }

              return NavigationActionPolicy.ALLOW;
            },
            // onReceivedHttpError: (InAppWebViewController controller, WebResourceRequest request, WebResourceResponse err) {
            //   setState(() {
            //     isLoading = false;
            //     error = true;
            //   });
            //   errorText = err.reasonPhrase!;
            //
            // },
            onReceivedServerTrustAuthRequest: (InAppWebViewController controller, URLAuthenticationChallenge challenge) async  {

              SslError? sslCertificateError = SslError();
              sslCertificateError = challenge.protectionSpace.sslError;
              return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
              // if(sslCertificateError != null){
              //     setState(() {
              //       isLoading = false;
              //       error = true;
              //     });
              //     errorText = sslCertificateError.message!;
              // }
            },
        ),
        if(isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
          if(error)
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Center(
                child: Text(errorText),
              ),
            )
        ]
      )
    );
  }
}
