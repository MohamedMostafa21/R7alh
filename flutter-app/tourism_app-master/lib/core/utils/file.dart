import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:tourism_app/core/utils/utils.dart';
//import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class FileDetails {
  static Future<File> urlToFile({required String url, required String nameFile}) async {
    // Get the temporary directory on the device.
    final tempDirectory = await getTemporaryDirectory();

    // Create a unique filename for the file.
    final filename = nameFile;

    // Download the file from the URL.
    final response = await http.get(Uri.parse(url));

    // Save the file to the temporary directory.
    final file = File('${tempDirectory.path}/$filename');
    await file.writeAsBytes(response.bodyBytes);
    printDM('File Before $filename $file');
    file.open();
    //await openDownloadedFile(file.path);
    // Return the File object.
    return file;
  }

  static Future<void> openFile(String url) async {
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  }

/*static Future<void> openDownloadedFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      // Error handling
      printDM(result.message);
    }
  }*/
}
