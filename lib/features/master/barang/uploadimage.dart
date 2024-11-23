// ignore_for_file: avoid_print

import 'dart:io' as io;
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart'; // file_picker for cross-platform file selection
import 'package:image_picker/image_picker.dart'; // image_picker for image selection
import 'package:flutter/foundation.dart';
import 'package:leontech/core/utils/function_string.dart'; // kIsWeb to detect if we are on Web
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class UploadImageWidget extends StatefulWidget {
  final String? initialImage;
  final Function(dynamic, String)? onUpload;

  const UploadImageWidget({super.key, this.initialImage, this.onUpload});

  @override
  State createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  String? imageUrl;
  Uint8List? resultImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    imageUrl = widget.initialImage;
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      try {
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          resultImage = await image.readAsBytes();
          imageUrl = image.path;
          if (resultImage != null) {
            widget.onUpload?.call(resultImage, imageUrl ?? '');
          }
          setState(() {});
        }
      } catch (e) {
        print("e: $e");
      }
      //   }
    } else if (io.Platform.isAndroid || io.Platform.isWindows) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        resultImage = await image.readAsBytes();
        imageUrl = image.path;
        if (resultImage != null) {
          widget.onUpload?.call(resultImage, imageUrl ?? '');
        }
        setState(() {});
      }
    } else if (io.Platform.isIOS) {
      // For iOS, use image_picker
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageUrl = pickedFile.path;
          if (resultImage != null) {
            widget.onUpload?.call(imageUrl, imageUrl ?? '');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          child: Column(
            children: [
              Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                          // border: Border.all(color: Colors.blue, width: 1),
                          ),
                      child: resultImage != null
                          ? Image.memory(resultImage!)
                          : imageUrl == null
                              ? Image.asset('assets/no-image.png',
                                  fit: BoxFit.cover)
                              : CachedNetworkImage(
                                  imageUrl: (imageUrl!),
                                  progressIndicatorBuilder:
                                      (context, url, progress) =>
                                          CircularProgressIndicator(
                                              value: progress.progress),
                                  errorWidget: (xctx, a, b) => Image.asset(
                                      'assets/no-image.png',
                                      height: 200,
                                      width: 200),
                                  fit: BoxFit.cover,
                                ))),
              const Text('Pilih gambar untuk meng-upload'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            print('mencoba klik pilih gambar');
            _pickImage();
          },
          child: const Text('Pilih Gambar'),
        ),
      ],
    );
  }
}

Future<void> uploadImage(String apiUrl, String id, Uint8List fileBytes,
    String path, String? oldImage) async {
  try {
    // Membaca file gambar
    // final fileBytes = await imageFile.readAsBytes();

    // Menentukan jenis MIME dari file
    // final mimeType = lookupMimeType(imageFile.path);
    final mimeType = lookupMimeType(path);

    final mediaType = mimeType != null
        ? MediaType.parse(mimeType)
        : MediaType('application', 'octet-stream');

    // Membuat multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..fields['oldFileName'] = oldImage ??
          '' // Contoh jika ingin mengirimkan file lama untuk dihapus
      ..files.add(http.MultipartFile.fromBytes(
        'file', // Field name yang diterima di backend
        fileBytes,
        filename: path.split('/').last,
        contentType: mediaType,
      ));

    // Kirim request dan tunggu responsnya
    var response = await request.send();

    if (response.statusCode == 200) {
      dp('File uploaded successfully!');
    } else {
      dp('Failed to upload file. Status code: ${response.statusCode}');
    }
  } catch (e) {
    dp('Error occurred while uploading the image: $e');
  }
}
