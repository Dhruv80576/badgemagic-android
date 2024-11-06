import 'dart:convert';
import 'dart:ui' as ui;

import 'package:badgemagic/bademagic_module/utils/byte_array_utils.dart';
import 'package:badgemagic/bademagic_module/utils/file_helper.dart';
import 'package:badgemagic/bademagic_module/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InlineImageProvider extends ChangeNotifier {
  //boolean variable to check for isCacheInitialized
  bool isCacheInitialized = false;

  List<MapEntry<String, Map<String, dynamic>>> savedBadgeCache = [];

  //set of available keys
  Set<int> availableKeys = {};

  bool isBackSpacePressed = false;

  void setBackSpacePressed(bool value) {
    isBackSpacePressed = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  bool isSavedBadgeData = false;

  //list of vectors
  List<String> vectors = [];

  //cache for storing cliparts
  Map<String, List<List<int>>?> clipartsCache = {};

  void setIsSavedBadgeData(bool value) {
    isSavedBadgeData = value;
    notifyListeners();
  }

  bool getIsSavedBadgeData() => isSavedBadgeData;

  //uses the AssetManifest class to load the list of assets
  Future<void> initVectors() async {
    vectors.clear();
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final imageAssetsList = manifestMap.keys
          .where((String key) => key.startsWith('assets/vectors/'))
          .toList();
      vectors.addAll(imageAssetsList);
      notifyListeners();
    } catch (e) {
      logger.e('Error loading asset manifest: $e');
    }
  }

  //to test the delete operation in TextField
  //used for compairing the length of the current textfield and the prevous
  //if the length of the current controller length is greater than the previous (add operation)
  //else delte operation is performed.
  int controllerLength = 0;

  //object of ImageUtils class to generate ImageCache
  ImageUtils imageUtils = ImageUtils();

  //controller for the Textfield
  TextEditingController message = TextEditingController();

  //getter for the textfield controller
  TextEditingController getController() => message;

  //selected index of the vector from the list
  late int selectedVector;

  BuildContext? context;

  void setContext(BuildContext context) {
    this.context = context;
  }

  BuildContext? get getContext => context;

  //Map to store the cache of the images generated
  //Image caches are generated at the splash screen
  //The cache generation time acts as a delay in the splash screen
  Map<Object, Uint8List?> imageCache = {};

  void removeFromCache(String key) {
    imageCache.remove(key);
    logger.d('Removed from cache: ${imageCache.containsKey(key)}');
    notifyListeners();
  }

  //function that generates the image cache
  //it fills the map with the Unit8List(byte Array) of the images
  Future<void> generateImageCache() async {
    imageCache.clear();
    FileHelper fileHelper = FileHelper();
    await initVectors();
    for (int x = 0; x < vectors.length; x++) {
      ui.Image image = await imageUtils.generateImageView(vectors[x]);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var unit8List = byteData!.buffer.asUint8List();
      imageCache[x] = unit8List;
    }
    fileHelper.loadImageCacheFromFiles();
    notifyListeners();
  }

  void insertInlineImage(Object key) {
    int index = 0;
    if (key is int) {
      index = key;
    } else if (key is List) {
      index = key[1];
    }
    logger.d('Inserting image at index: $index');
    String placeholder = index < 10 ? '<<0$index>>' : '<<$index>>';
    int cursorPos =
        message.selection.baseOffset == -1 ? 0 : message.selection.baseOffset;
    String beforeCursor = message.text.substring(0, cursorPos);
    String afterCursor = message.text.substring(cursorPos);
    message.text = beforeCursor + placeholder + afterCursor;
    message.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPos + placeholder.length));
  }

  void controllerListener() {
    int cursorPosition = message.selection.baseOffset;
    if (cursorPosition < 0) {
      return;
    }
    logger.i(
        'message in controller: ${message.text} Cursor position: $cursorPosition');
    int textLength = message.text.length;
    if (textLength >= 5) {
      if (cursorPosition == textLength) {
        if (message.text[textLength - 1] == '>' &&
            message.text[textLength - 4] == '<') {
          message.text = message.text.substring(0, textLength - 5);
        }
      } else {
        if (message.text[cursorPosition - 1] == '>' &&
            message.text[cursorPosition - 4] == '<' &&
            isBackSpacePressed) {
          message.text = message.text.substring(0, cursorPosition - 5) +
              message.text.substring(cursorPosition + 1);
        }
      }
    }
  }

  void moveCursorToEnd() {
    message.selection = TextSelection.fromPosition(
      TextPosition(offset: message.text.length),
    );
    notifyListeners();
  }

  void deleteInlineImage(int start, int end) {
    String text = message.text;
    String before = text.substring(0, start);
    String after = text.substring(end);
    message.text = before + after;
    message.selection = TextSelection.fromPosition(
      TextPosition(offset: 0),
    );
    notifyListeners();
  }

  void handleDelete() {
    int start = message.selection.baseOffset;
    int end = message.selection.extentOffset;
    if (start == end) {
      // Handle backspace
      if (start > 0) {
        String text = message.text;
        int deleteStart = start - 1;
        int deleteEnd = start;
        // Check if we are deleting a placeholder
        if (text.substring(deleteStart, deleteEnd) == '>') {
          int placeholderStart = text.lastIndexOf('<<', deleteStart);
          if (placeholderStart != -1) {
            deleteStart = placeholderStart;
          }
        }
        deleteInlineImage(deleteStart, deleteEnd);
      }
    } else {
      // String text = message.text;
      // int deleteStart = start - 1;
      // int deleteEnd = start;
      // // Check if we are deleting a placeholder
      // if (text.substring(deleteStart, deleteEnd) == '>') {
      //   int placeholderStart = text.lastIndexOf('<<', deleteStart);
      //   if (placeholderStart != -1) {
      //     deleteStart = placeholderStart;
      //   }
      // }
      // deleteInlineImage(deleteStart, deleteEnd);
    }
  }
}
