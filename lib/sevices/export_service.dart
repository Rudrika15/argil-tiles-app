import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:argil_tiles/app_const/app_color.dart';
import 'package:argil_tiles/utils/api_helper/api_hepler.dart';
import 'package:argil_tiles/utils/shared_preference/shared_prefrence.dart';
import 'package:argil_tiles/utils/widget_helper/widhet_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  /// Export contact inquiries sheet and share
  Future<bool> exportContacts({required BuildContext context}) async {
    return await _exportAndShare(
      context: context,
      url: ApiHelper.exportContact,
      defaultFileName: 'contacts_export.xlsx',
    );
  }

  /// Export product inquiries sheet and share
  Future<bool> exportInquiries({required BuildContext context}) async {
    return await _exportAndShare(
      context: context,
      url: ApiHelper.exportInquiry,
      defaultFileName: 'inquiries_export.xlsx',
    );
  }

  Future<bool> _exportAndShare({
    required BuildContext context,
    required String url,
    required String defaultFileName,
  }) async {
    try {
      final token = await SharedPrefs.getToken();
      final headers = <String, String>{
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        'Accept': '*/*',
      };

      log("Exporting sheet from: $url");
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'] ?? '';

        // Check if response is JSON (e.g. contains URL or message)
        if (contentType.contains('application/json') ||
            response.body.trim().startsWith('{')) {
          try {
            final data = jsonDecode(response.body);
            final fileUrl = data['url'] ??
                data['file_url'] ??
                data['download_url'] ??
                data['file'] ??
                data['data']?['url'];

            if (fileUrl != null && fileUrl.toString().isNotEmpty) {
              return await _downloadAndShare(
                context: context,
                fileUrl: fileUrl.toString(),
                fileName: defaultFileName,
              );
            } else if (data['success'] == false || data['message'] != null) {
              if (context.mounted) {
                WidgetHelper.customSnackBar(
                  context: context,
                  title: data['message'] ?? 'Failed to export sheet',
                  color: AppColors.errorColor,
                  isError: true,
                );
              }
              return false;
            }
          } catch (_) {
            // If jsonDecode fails, proceed with bodyBytes
          }
        }

        // Handle binary file response (Excel, CSV, etc.)
        String fileName = defaultFileName;
        final contentDisposition =
            response.headers['content-disposition'] ?? '';
        final match = RegExp(
          r'filename[^;=\n]*=(([\x27\x22]).*?\2|[^;\n]*)',
        ).firstMatch(contentDisposition);
        if (match != null && match.group(1) != null) {
          fileName = match
              .group(1)!
              .replaceAll('"', '')
              .replaceAll("'", '')
              .trim();
        } else if (contentType.contains('csv')) {
          fileName = defaultFileName.replaceAll('.xlsx', '.csv');
        }

        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        RenderBox? box;
        if (context.mounted) {
          box = context.findRenderObject() as RenderBox?;
        }

        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text: 'Exported $fileName',
            sharePositionOrigin: box != null
                ? (box.localToGlobal(Offset.zero) & box.size)
                : null,
          ),
        );

        if (context.mounted) {
          WidgetHelper.customSnackBar(
            context: context,
            title: 'Sheet exported successfully',
            color: AppColors.brown,
            isError: false,
          );
        }
        return true;
      } else if (response.statusCode == 401) {
        if (context.mounted) {
          WidgetHelper.customSnackBar(
            context: context,
            title: 'Session expired. Please log in again.',
            color: AppColors.errorColor,
            isError: true,
          );
        }
        return false;
      } else if (response.statusCode == 404) {
        if (context.mounted) {
          WidgetHelper.customSnackBar(
            context: context,
            title: 'Export endpoint not found on server (404)',
            color: AppColors.errorColor,
            isError: true,
          );
        }
        return false;
      } else {
        if (context.mounted) {
          WidgetHelper.customSnackBar(
            context: context,
            title: 'Failed to export: Server error (${response.statusCode})',
            color: AppColors.errorColor,
            isError: true,
          );
        }
        return false;
      }
    } catch (e) {
      log("Error while exporting: $e");
      if (context.mounted) {
        WidgetHelper.customSnackBar(
          context: context,
          title: 'Error exporting sheet: $e',
          color: AppColors.errorColor,
          isError: true,
        );
      }
      return false;
    }
  }

  Future<bool> _downloadAndShare({
    required BuildContext context,
    required String fileUrl,
    required String fileName,
  }) async {
    try {
      final res = await http.get(Uri.parse(fileUrl));
      if (res.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(res.bodyBytes);

        RenderBox? box;
        if (context.mounted) {
          box = context.findRenderObject() as RenderBox?;
        }

        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text: 'Exported $fileName',
            sharePositionOrigin: box != null
                ? (box.localToGlobal(Offset.zero) & box.size)
                : null,
          ),
        );
        return true;
      } else {
        await SharePlus.instance.share(
          ShareParams(
            text: fileUrl,
            subject: 'Exported $fileName',
          ),
        );
        return true;
      }
    } catch (e) {
      log("Error downloading file: $e");
      await SharePlus.instance.share(
        ShareParams(
          text: fileUrl,
          subject: 'Exported $fileName',
        ),
      );
      return true;
    }
  }
}
