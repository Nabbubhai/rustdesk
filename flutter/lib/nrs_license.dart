// NRS Heartbeat Licensing
// Calls /api/check-license on startup.
// approved  → silent, agent starts normally
// pending   → shows "pending approval" dialog
// blocked   → shows "access blocked" dialog
// unreachable → allow through (don't lock out if server is down)

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class NrsLicense {
  static const _licenseUrl = 'https://nrs.jindalsaw.com/api/check-license';
  static const _machineIdFile = 'nrs_mid.dat';

  static Future<String> _getMachineId() async {
    try {
      final dir = await _configDir();
      final file = File('${dir.path}${Platform.pathSeparator}$_machineIdFile');
      if (await file.exists()) {
        final id = (await file.readAsString()).trim();
        if (id.isNotEmpty) return id;
      }
      final id = const Uuid().v4();
      await dir.create(recursive: true);
      await file.writeAsString(id);
      return id;
    } catch (_) {
      return const Uuid().v4();
    }
  }

  static Future<Directory> _configDir() async {
    final appData = Platform.environment['APPDATA'] ??
        Platform.environment['HOME'] ??
        '.';
    return Directory('$appData${Platform.pathSeparator}com.carriez.flutter_hbb');
  }

  static Future<void> check() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final machineId = await _getMachineId();
      final hostname = Platform.localHostname;
      final windowsUsername =
          Platform.environment['USERNAME'] ??
          Platform.environment['USER'] ??
          'unknown';

      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 10)
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      final req = await client.postUrl(Uri.parse(_licenseUrl));
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode({
        'hostname': hostname,
        'windows_username': windowsUsername,
        'machine_id': machineId,
      }));

      final resp = await req.close().timeout(const Duration(seconds: 10));
      final body = await resp.transform(utf8.decoder).join();
      client.close();

      final Map<String, dynamic> data = jsonDecode(body);
      final status = data['status'] as String? ?? 'error';

      if (status == 'pending') {
        _showDialog(
          title: 'Approval Pending',
          icon: Icons.hourglass_top_rounded,
          iconColor: const Color(0xFFFBBF24),
          message:
              'Your device is registered and pending approval by IT.\n\n'
              'Please contact:\nMr. Navneet Sharma\n'
              'Navneet.Sharma@jindalsaw.com',
        );
      } else if (status == 'blocked') {
        _showDialog(
          title: 'Access Blocked',
          icon: Icons.block_rounded,
          iconColor: const Color(0xFFEF4444),
          message:
              'Remote support access for this device has been blocked.\n\n'
              'Please contact:\nMr. Navneet Sharma\n'
              'Navneet.Sharma@jindalsaw.com',
        );
      }
    } catch (_) {
      // Server unreachable → allow through silently
    }
  }

  static void _showDialog({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String message,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFF1F5F9),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 340,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF1E3A5F)),
                ),
                child: const Text(
                  'JSAW Remote Support  ·  IT Department',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK',
                style: TextStyle(color: Color(0xFF60A5FA))),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
