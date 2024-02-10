import 'package:abushakir/abushakir.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceCard extends StatefulWidget {
  final String title;
  final String price;
  final String subPriceText;
  final String billedText;
  final int duration;
  final VoidCallback? onPress;
  const PriceCard({super.key, required this.title, required this.price, required this.subPriceText, required this.billedText, required this.duration, this.onPress});

  @override
  State<PriceCard> createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Duration duration = Duration(days: widget.duration*30);
    DateTime expirationDate = now.add(duration);
    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF8FAFC),
        border: Border.all(
          color: Colors.black54,
          width: 0.3,
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.billedText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
              ),
            ),
            Text(
              '${Language.getLocaleCode() == 'en'? 'Birr': "ብር"} ${widget.price}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'
              ),
            ),
            Text(
              '${Language.getLocaleCode() == 'en'? 'Good until': "እስከ"} ${Language.getLocaleCode() == 'en'?DateFormat('MMMM dd, yyyy').format(expirationDate): '${EtDatetime.fromMillisecondsSinceEpoch(expirationDate.millisecondsSinceEpoch,).monthGeez} ${EtDatetime.fromMillisecondsSinceEpoch(expirationDate.millisecondsSinceEpoch,).day}, ${EtDatetime.fromMillisecondsSinceEpoch(expirationDate.millisecondsSinceEpoch,).year}'}',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12
              )
            ),
            GestureDetector(
              onTap: widget.onPress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFF5801E)
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${Language.getLocaleCode() == 'en'? 'Get plan': "ሰብስክራይብ ያድርጉ"}',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                          fontSize: 12
                        )
                    ),
                  ),
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}
