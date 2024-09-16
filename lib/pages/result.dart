import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:sneakers_counterfeit_detector/constants.dart';
import 'package:sneakers_counterfeit_detector/utils/debug.dart';

enum ResultLoadingState {
 loadingModel,
 performingDetection,
 finished
}

enum Result {
  noDetection,
  fake,
  real
}

class ResultPage extends StatefulWidget {
  final File appearanceImageFile;
  final File labelImageFile;
  final File insoleBackImageFile;
  final File insoleStitchImageFile;  

  const ResultPage({ 
    super.key, 
    required this.appearanceImageFile,
    required this.labelImageFile,
    required this.insoleBackImageFile,
    required this.insoleStitchImageFile,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Result? result;
  late FlutterVision vision;
  ResultLoadingState loadingState = ResultLoadingState.loadingModel;

  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    loadYoloModel().then((_) {
      setState(() {
        result = null;
        loadingState = ResultLoadingState.performingDetection;
      });
      
      performDetection();
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIconData;

    switch (result) {
      case Result.real:
        statusColor = CupertinoColors.activeGreen;
        statusText = "Your sneakers have passed the authenticity check.";
        statusIconData = CupertinoIcons.checkmark_alt;
        break;
      case Result.fake:
        statusColor = CupertinoColors.systemRed;
        statusText = "Your sneakers have failed the authenticity check.";
        statusIconData = CupertinoIcons.xmark;
      case null:
      case Result.noDetection:
        statusColor = CupertinoColors.systemYellow;
        statusText = "No sneakers detected";
        statusIconData = CupertinoIcons.question;
        break;   
    }

    DateTime now = DateTime.now().toLocal();
    String nowString = now.toString().substring(0, 10);
    
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            backgroundColor: CupertinoColors.white,
            leading: CupertinoNavigationBarBackButton(
              previousPageTitle: "Back",
              onPressed: () => Navigator.of(context).pop(),
            ),
            largeTitle: const Text(
              "Results", 
              style: TextStyle(
                color: CupertinoColors.label,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: CupertinoColors.extraLightBackgroundGray,
              padding: const EdgeInsets.all(24.0),
              child: loadingState == ResultLoadingState.finished ? (
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: CupertinoColors.systemGrey5),
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.lightBackgroundGray.withOpacity(0.75),
                                spreadRadius: 4,
                                blurRadius: 6,
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: CupertinoColors.white,
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                      top: 64,
                                      bottom: 24,
                                      left: 24,
                                      right: 24
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Shoethenticator", 
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ),
                                        Text(
                                          "Certificate of Authenticity",
                                          style: TextStyle(
                                            color: CupertinoColors.secondaryLabel,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                    top: 36.0,
                                    bottom: 36.0,
                                    left: 24.0,
                                    right: 24.0,
                                  ),
                                  color: statusColor,
                                  child: Column(
                                    children: [
                                      Icon(
                                        statusIconData,
                                        size: 96,
                                        color: CupertinoColors.white,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        statusText, 
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                          color: CupertinoColors.white
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: CupertinoColors.white,
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Model", style: TextStyle(fontWeight: FontWeight.w500)),
                                          Text("Jordan 1")
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Date Checked", style: TextStyle(fontWeight: FontWeight.w500)),
                                          Text(nowString)
                                        ],
                                      ),
                                      const SizedBox(height: 32),
                                      Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.center,
                                        spacing: 4,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: Image.file(
                                              widget.appearanceImageFile, 
                                              width: 48, 
                                              height: 48
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: Image.file(
                                              widget.labelImageFile, 
                                              width: 48, 
                                              height: 48
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: Image.file(
                                              widget.insoleBackImageFile, 
                                              width: 48, 
                                              height: 48
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: Image.file(
                                              widget.insoleStitchImageFile, 
                                              width: 48, 
                                              height: 48
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -56,
                          child: Container(
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              border: Border.all(
                                color: CupertinoColors.systemGrey5,
                                width: 1
                              ),
                              borderRadius: BorderRadius.circular(16)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                logoPath, 
                                width: 96, 
                                height: 96
                              ),
                            )
                          )
                        )                        
                      ],
                    )
                  ],
                )
              ) : (
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CupertinoActivityIndicator(radius: 20),
                    Text(
                      loadingState == ResultLoadingState.loadingModel ? 
                        "Loading model" : 
                        "Performing detection"
                    )
                  ],
                )
              ),
            ))
        ],
      )
    );
  }

    Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
      modelPath: modelPath, 
      labels: labelsPath, 
      modelVersion: "yolov8",
      quantization: false,
      numThreads: 2,
      useGpu: true
    );
  }

  Future<void> performDetection() async {
    result = null;
    
    Uint8List byte = await widget.appearanceImageFile.readAsBytes();
    final image = await decodeImageFromList(byte);
    final detections = await vision.yoloOnImage(
      bytesList: byte,
      imageHeight: image.height,
      imageWidth: image.width,
      iouThreshold: 0.8,
      confThreshold: 0.4,
      classThreshold: 0.5
    );

    Result detectionResult;
        
    if (detections.isNotEmpty) {
      customDebugPrint("There are results!");
      customDebugPrint(detections.toString());
      
      bool hasFake = detections.any((detection) => detection["tag"] == "fake");

      customDebugPrint("RESULT: ${hasFake ? "FAKE" : "REAL"}");
      
      detectionResult = hasFake ? Result.fake : Result.real;
    } else {
      detectionResult = Result.noDetection;
    }

    setState(() {
      loadingState = ResultLoadingState.finished;
      result = detectionResult;
    });
  }
}