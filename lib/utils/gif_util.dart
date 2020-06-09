import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class GifUtil {
  static Future<void> downloadFile(
      String url, String name, ProgressCallback onProgress) async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      var dio = Dio();
      print("NAME: ${dir.path}/$name");
      await dio.download(url, "${dir.path}/$name",
          onReceiveProgress: onProgress);
    } catch (e) {
      throw ("Download error. Error: ${e.toString()}");
    }
  }

  static Future<void> shareGif(String name) async {
    var dir = await getApplicationDocumentsDirectory();
//    Share.share("${dir.path}/$name", subject: "Gif One");
    ShareExtend.share("${dir.path}/$name", "image");
  }

  static String getTitulo(String titulo) {
    try {
      if ((titulo.trim().isEmpty) || (titulo.trim().length == 0)) {
        titulo = tr('noTitle');
        return titulo;
      } else {
        int index = titulo.toLowerCase().indexOf("sticker by");
        String title = titulo.substring(0, index);
        title = title.replaceAllMapped(
            new RegExp(r'((coronavirus|covid|corona|coronavírus))',
                caseSensitive: false),
            (match) => "Nope");

        return title;
      }
    } catch (e) {
      return titulo;
    }
  }
}
