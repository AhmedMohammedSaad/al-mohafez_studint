import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    super.key,
    required this.text,
    this.style,
    this.expandButtonStyle,
    this.maxLines = 3,
    this.expandText = 'See more',
    this.collapseText = 'See less',
    this.textAlign = TextAlign.left,
    this.expandOnlyOnButton = false,
    this.overflow = TextOverflow.ellipsis,
  });
  final String text;
  final TextStyle? style;
  final TextStyle? expandButtonStyle;
  final int maxLines;
  final String expandText;
  final String collapseText;
  final TextAlign textAlign;
  final bool expandOnlyOnButton;
  final TextOverflow overflow;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  late TextSpan _textSpan;
  late TextPainter _textPainter;
  bool _needsToExpand = false;

  @override
  void initState() {
    super.initState();
    _textSpan = TextSpan(text: widget.text, style: widget.style);
    _textPainter = TextPainter(
      text: _textSpan,
      textDirection: TextDirection.ltr,
      maxLines: widget.maxLines,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTextPainter();
  }

  @override
  void didUpdateWidget(ExpandableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.style != widget.style) {
      _textSpan = TextSpan(text: widget.text, style: widget.style);
      _textPainter.text = _textSpan;
      _updateTextPainter();
    }
  }

  void _updateTextPainter() {
    // Update with available width
    final size = MediaQuery.of(context).size;
    _textPainter.layout(maxWidth: size.width);

    // Check if the text needs expanding
    _needsToExpand = _textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultStyle = widget.style ?? Theme.of(context).textTheme.bodyMedium!;
    final TextStyle expandButtonStyle = widget.expandButtonStyle ??
        defaultStyle.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.expandOnlyOnButton
              ? null
              : () {
                  if (_needsToExpand) {
                    setState(() => _expanded = !_expanded);
                  }
                },
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.text,
              style: defaultStyle,
              textAlign: widget.textAlign,
              maxLines: _expanded ? null : widget.maxLines,
              overflow: _expanded ? null : widget.overflow,
            ),
          ),
        ),
        if (_needsToExpand)
          GestureDetector(
            onTap: () {
              setState(() => _expanded = !_expanded);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                _expanded ? widget.collapseText : widget.expandText,
                style: expandButtonStyle,
              ),
            ),
          ),
      ],
    );
  }
}
