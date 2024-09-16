import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneakers_counterfeit_detector/constants.dart';
import 'package:sneakers_counterfeit_detector/utils/text.dart';

class CategoryInput extends StatefulWidget {
  final String name;
  final String iconPath;
  final File? imageFile;
  final Function(File? newImageFile) setImageFile;

  const CategoryInput({ 
    super.key, 
    required this.name, 
    required this.iconPath,
    required this.imageFile,
    required this.setImageFile
  });
  
  @override
  State<StatefulWidget> createState() => _CategoryInputState();
}

class _CategoryInputState extends State<CategoryInput> {
  void _selectCategoryImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      widget.setImageFile(File(photo.path));
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showCupertinoDialog(
      context: context, 
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("Remove ${widget.name} image?"),
        content: Text("${getFileNameFromPath(widget.imageFile!.path)} will be unselected as the Appearance image."),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              widget.setImageFile(null);
              Navigator.pop(context);
            },
            child: const Text('Remove')
          )
        ],
      )
    );
  }

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
          Expanded(
            child: Row(
              children: [
                widget.imageFile == null ? (
                  SvgPicture.asset(
                    widget.iconPath,
                    width: 32,
                    height: 32,
                    colorFilter: const ColorFilter.mode(CupertinoColors.secondaryLabel, BlendMode.srcIn),
                  )
                ) : (
                  Image.file(widget.imageFile!, width: 32, height: 32)
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name, 
                        style: const TextStyle(
                          color: CupertinoColors.label,
                        )
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        widget.imageFile == null ? "No file selected" : getFileNameFromPath(widget.imageFile!.path),
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: CupertinoColors.secondaryLabel,
                          overflow: TextOverflow.ellipsis
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          widget.imageFile == null ? (
            CupertinoButton(
              onPressed: _selectCategoryImage,
              child: const Text(
                "Upload", 
                style: TextStyle(fontSize: 14.0)
              ),
            )
          ) : (
            Row(
              children: [
                CupertinoButton(
                  onPressed: _selectCategoryImage,
                  padding: EdgeInsets.zero,
                  child: const Text(
                    "Edit", 
                    style: TextStyle(
                      fontSize: 14.0
                    )
                  ), 
                ),
                const SizedBox(width: 4.0),
                CupertinoButton(
                  onPressed: () => _showDeleteDialog(context),
                  padding: EdgeInsets.zero,
                  child: const Text(
                    "Remove", 
                    style: TextStyle(
                      color: CupertinoColors.destructiveRed,
                      fontSize: 14.0
                    )
                  ), 
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}