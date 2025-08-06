import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

class TopicDetailWidget extends StatelessWidget {
  final String title;
  final String content;
  const TopicDetailWidget({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 16.0),
        child: Markdown(
          data: content,
          physics: const AlwaysScrollableScrollPhysics(),
          styleSheet: MarkdownStyleSheet(
            blockSpacing: 10.0,
            codeblockPadding: const EdgeInsets.all(18.0),
            codeblockDecoration: BoxDecoration(
              color: Colors.grey.shade200,
            )
          ),
           extensionSet: md.ExtensionSet(
            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
            <md.InlineSyntax>[
              md.EmojiSyntax(),
              ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
            ],
          ),
          // extensionSet: ExtensionS,
        ),
      ),
    );
  }
}