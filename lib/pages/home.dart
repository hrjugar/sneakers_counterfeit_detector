import 'package:flutter/cupertino.dart';

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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Sneakers Counterfeit Detector"),
        backgroundColor: CupertinoColors.white,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: CupertinoColors.extraLightBackgroundGray,
        child: Column(
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
          ],
        ),
      ),
    );
  }
}
