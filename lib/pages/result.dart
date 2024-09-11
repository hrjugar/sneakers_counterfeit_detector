import 'dart:io';

import 'package:flutter/cupertino.dart';

class ResultPage extends StatefulWidget {
  final File appearanceImageFile;
  final File labelImageFile;
  final File insoleBackImageFile;
  final File insoleStitchingImageFile;

  const ResultPage({ 
    super.key, 
    required this.appearanceImageFile, 
    required this.labelImageFile, 
    required this.insoleBackImageFile, 
    required this.insoleStitchingImageFile,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            leading: CupertinoNavigationBarBackButton(
              previousPageTitle: "Back",
              onPressed: () => Navigator.of(context).pop(),
            ),
            largeTitle: const Text("Results"),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading ? (
                const CupertinoActivityIndicator(radius: 20.0)
              ) : (
                const Column(
                  children: [
                    Text("Let's go!")
                  ],
                )
              )
            ),
          )
        ],
      )
    );
  }
}