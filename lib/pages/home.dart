import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sneakers_counterfeit_detector/constants.dart';
import 'package:sneakers_counterfeit_detector/pages/result.dart';
import 'package:sneakers_counterfeit_detector/widgets/category_input.dart';

const List<String> _sneakersList = [
  "Jordan 1"
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedSneakerIndex = 0;
  
  File? _appearanceImageFile;
  File? _labelImageFile;
  File? _insoleBackImageFile;
  File? _insoleStitchImageFile;

  void _showModelPicker() {
    showCupertinoModalPopup(
      context: context, 
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            itemExtent: 32.0, 
            onSelectedItemChanged: (int selectedItemIndex) {
              setState(() {
                _selectedSneakerIndex = selectedItemIndex;
              });
            }, 
            children: List<Widget>.generate(_sneakersList.length, (int index) {
              return Center(child: Text(_sneakersList[index]));
            })
          ),
        ),                
      )
    );
  }

  void _submit() {
    
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Sneakers Counterfeit Detector"),
        backgroundColor: CupertinoColors.white,
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: CupertinoColors.extraLightBackgroundGray,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CupertinoButton(
                    onPressed: null,
                    color: CupertinoColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Model", style: TextStyle(color: CupertinoColors.inactiveGray)),
                        Row(
                          children: [
                            Text(
                              _sneakersList[_selectedSneakerIndex], 
                              style: const TextStyle(color: CupertinoColors.inactiveGray)
                            ),
                            const SizedBox(width: 16.0),
                            const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.inactiveGray),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  const Text(
                    "IMAGES", 
                    style: TextStyle(
                      color: CupertinoColors.secondaryLabel,
                      fontSize: 13,
                    )
                  ),
                  const SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CategoryInput(
                        name: "Appearance", 
                        iconPath: shoeSvgPath, 
                        imageFile: _appearanceImageFile, 
                        setImageFile: (File? newImageFile) {
                          setState(() {
                            _appearanceImageFile = newImageFile;
                          });
                        }
                      ),
                      const SizedBox(height: 8.0),
                      CategoryInput(
                        name: "Inside Label", 
                        iconPath: labelSvgPath,
                        imageFile: _labelImageFile,
                        setImageFile: (File? newImageFile) {
                          setState(() {
                            _labelImageFile = newImageFile;
                          });
                        },
                      ),
                      const SizedBox(height: 8.0),
                      CategoryInput(
                        name: "Back of Insole", 
                        iconPath: insoleSvgPath,
                        imageFile: _insoleBackImageFile,
                        setImageFile: (File? newImageFile) {
                          setState(() {
                            _insoleBackImageFile = newImageFile;
                          });
                        },
                      ),
                      const SizedBox(height: 8.0),
                      CategoryInput(
                        name: "Insole Stitching", 
                        iconPath: stitchSvgPath,
                        imageFile: _insoleStitchImageFile,
                        setImageFile: (File? newImageFile) {
                          setState(() {
                            _insoleStitchImageFile = newImageFile;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: (
                      _appearanceImageFile == null || 
                      _labelImageFile == null ||
                      _insoleBackImageFile == null ||
                      _insoleStitchImageFile == null
                    ) ? null : () {
                      Navigator.push(
                        context, 
                        CupertinoPageRoute(
                          builder: (BuildContext context) => ResultPage(
                              appearanceImageFile: _appearanceImageFile!,
                              labelImageFile: _labelImageFile!,
                              insoleBackImageFile: _insoleBackImageFile!,
                              insoleStitchImageFile: _insoleStitchImageFile!,
                          )
                        )
                      );
                    },
                    child: const Text("Submit"), 
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
