class Verification{
  String? checkoutUrl;
  String? txref;



  Verification({
    this.checkoutUrl,
    this.txref,
  });

  Verification.fromJson(Map<dynamic, dynamic> json) {
    checkoutUrl = json['data']['data']['checkout_url'];
    txref = json['tx_ref'];
  }
}