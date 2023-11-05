import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchInputField extends StatefulWidget {
  final String hint;
  final bool enabled;
  final ValueChanged<String>? onSearchQueryChange;
  final FocusNode? focusNode;

  const SearchInputField(
      {super.key,
      this.onSearchQueryChange,
      this.enabled = false,
      this.focusNode,
      required this.hint});

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      // width: 330,
      // height: 50,
      child: TextFormField(
        focusNode: widget.focusNode,
        onChanged: widget.onSearchQueryChange,
        enabled: widget.enabled,
        keyboardType: TextInputType.text,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: theme.colorScheme.secondaryContainer),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              color: theme.colorScheme.secondaryContainer,
              width: 1,
            ),
          ),
          prefixIcon: Icon(CupertinoIcons.search,
              color: theme.colorScheme.secondaryContainer),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.secondaryContainer,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
