library latext;

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class LaTexT extends StatefulWidget {
  // a Text used for the rendered code as well as for the style
  final Text laTeXCode;

  // The delimiter to be used for inline LaTeX
  final String delimiter;

  // The delimiter to be used for Display (centered, "important") LaTeX
  final String displayDelimiter;

  // The delimiter to be used for line breaks. Either \\ or \break.
  final String breakDelimiter;

  // A TextStyle used to apply styles exclusively to the mathematical equations of the laTeXCode.
  // If not provided, this variable will be ignored, and the laTeXCode style will be applied.
  final TextStyle? equationStyle;

  const LaTexT({
    super.key,
    required this.laTeXCode,
    this.equationStyle,
    this.delimiter = r'$',
    this.displayDelimiter = r'$$',
    this.breakDelimiter = r'\\',
  });

  @override
  State<LaTexT> createState() => LaTexTState();
}

class LaTexTState extends State<LaTexT> {
  @override
  Widget build(BuildContext context) {
    // Fetching the Widget's LaTeX code as well as it's [TextStyle]
    final laTeXCode = widget.laTeXCode.data!;
    final defaultTextStyle = widget.laTeXCode.style;

    // Building [RegExp] to find any Math part of the LaTeX code by looking for the specified delimiters
    final String delimiter = widget.delimiter.replaceAll(r'$', r'\$');
    final String displayDelimiter =
        widget.displayDelimiter.replaceAll(r'$', r'\$');

    final String rawRegExp =
        '(($delimiter)([^$delimiter]*[^\\\\\\$delimiter])($delimiter)|($displayDelimiter)([^$displayDelimiter]*[^\\\\\\$displayDelimiter])($displayDelimiter))';
    List<RegExpMatch> matches =
        RegExp(rawRegExp, dotAll: true).allMatches(laTeXCode).toList();

    // If no single Math part found, returning the raw [Text] from widget.laTeXCode
    if (matches.isEmpty) return widget.laTeXCode;

    // Otherwise looping threw all matches and building a [RichText] from [TextSpan] and [WidgetSpan] widgets
    final List<InlineSpan> textBlocks = [];
    int lastTextEnd = 0;

    for (final laTeXMatch in matches) {
      // If there is an offset between the lat match (beginning of the [String] in first case), first adding the found [Text]
      if (laTeXMatch.start > lastTextEnd) {
        textBlocks.addAll(
          _extractTextSpans(
            laTeXCode.substring(lastTextEnd, laTeXMatch.start),
          ),
        );
      }
      // Adding the [CaTeX] widget to the children
      if (laTeXMatch.group(3) != null) {
        textBlocks.addAll(
          _extractWidgetSpans(
            laTeXMatch.group(3)?.trim() ?? '',
            false,
          ),
        );
      } else {
        textBlocks.addAll([
          const TextSpan(text: '\n'),
          ..._extractWidgetSpans(laTeXMatch.group(6)?.trim() ?? '', true),
          const TextSpan(text: '\n')
        ]);
      }
      lastTextEnd = laTeXMatch.end;
    }

    // If there is any text left after the end of the last match, adding it to children
    if (lastTextEnd < laTeXCode.length) {
      textBlocks.addAll(
        _extractTextSpans(
          laTeXCode.substring(lastTextEnd),
        ),
      );
    }

    // Returning a RichText containing all the [TextSpan] and [WidgetSpan] created previously while
    // obeying the specified style in widget.laTeXCode
    return Text.rich(
      TextSpan(
        children: textBlocks,
        style: (defaultTextStyle == null)
            ? Theme.of(context).textTheme.bodyLarge
            : defaultTextStyle,
      ),
      textAlign: widget.laTeXCode.textAlign,
      textDirection: widget.laTeXCode.textDirection,
      locale: widget.laTeXCode.locale,
      softWrap: widget.laTeXCode.softWrap,
      overflow: widget.laTeXCode.overflow,
      maxLines: widget.laTeXCode.maxLines,
      semanticsLabel: widget.laTeXCode.semanticsLabel,
    );
  }

  List<TextSpan> _extractTextSpans(String text) {
    final texts = text.split(widget.breakDelimiter);
    final List<TextSpan> textSpans = [];
    for (int i = 0; i < texts.length; i++) {
      if (i != 0) {
        textSpans.add(
          const TextSpan(
            text: '\n',
          ),
        );
      }
      textSpans.add(
        TextSpan(
          text: texts[i].trim(),
        ),
      );
    }
    return textSpans;
  }

  List<InlineSpan> _extractWidgetSpans(String text, bool align) {
    final texts = text.split(widget.breakDelimiter);
    final List<InlineSpan> widgetSpans = [];
    for (int i = 0; i < texts.length; i++) {
      if (i != 0) {
        widgetSpans.add(
          const TextSpan(
            text: '\n',
          ),
        );
      }

      Widget tex = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Math.tex(
          texts[i].trim(),
          textStyle: (widget.equationStyle != null)
              ? widget.equationStyle
              : widget.laTeXCode.style,
        ),
      );

      if (align) {
        tex = Align(
          alignment: Alignment.center,
          child: tex,
        );
      }

      widgetSpans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: tex,
        ),
      );
    }

    return widgetSpans;
  }
}
