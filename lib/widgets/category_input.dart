import 'package:flutter/cupertino.dart';

class CategoryInput extends StatefulWidget {
  final String name;
  final IconData icon;

  const CategoryInput({ 
    super.key, 
    required this.name, 
    required this.icon 
  });
  
  @override
  State<StatefulWidget> createState() => _CategoryInputState();
}

class _CategoryInputState extends State<CategoryInput> {
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [ 
          Row(
            children: [
              imagePath == null ? (
                Icon(widget.icon, color: CupertinoColors.secondaryLabel, size: 32)
              ) : (
                Container(
                  width: 32.0,
                  height: 32.0,
                  color: CupertinoColors.placeholderText,
                )
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name, 
                    style: const TextStyle(
                      color: CupertinoColors.secondaryLabel,
                    )
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    imagePath == null ? "No file selected" : imagePath!,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: CupertinoColors.secondaryLabel
                    ),
                  )
                ],
              )
            ],
          ),
          imagePath == null ? (
            CupertinoButton(
              onPressed: () {},
              child: const Text("Upload"),
            )
          ) : (
            Row(
              children: [
                CupertinoButton(
                  onPressed: () {},
                  child: const Text("Edit"), 
                ),
                CupertinoButton(
                  onPressed: () {},
                  child: const Text("Delete"), 
                )
              ],
            )
          )
        ],
      ),
    );
  }
}