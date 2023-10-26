import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageField extends StatelessWidget {
  final dynamic imagePath;
  final VoidCallback onClicked;

  const ImageField({Key? key, required this.imagePath, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              buildImage(theme),
              if (imagePath != null)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Ink(
                    child: InkWell(
                        onTap: onClicked,
                        child: buildEditIcon(theme.colorScheme.primary)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildImage(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: double.infinity,
          height: 250,
          child: InkWell(
            child: imagePath != null
                ? Image.file(
                    imagePath,
                    fit: BoxFit.contain,
                  )
                : IconButton(
                    onPressed: onClicked,
                    icon: Icon(
                      Icons.image_outlined,
                      size: 50,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(8),
        color: color,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

}
