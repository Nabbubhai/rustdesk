// JSAW Remote Support — Settings stub
// Network settings are intentionally hidden.
// Server configuration is managed centrally by JSAW IT via server_model.dart.

import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:get/get.dart';

// All tab keys that callers reference — keep the full enum so nothing breaks.
enum SettingsTabKey { general, safety, display, codec, audio, network, about }

class DesktopSettingPage extends StatefulWidget {
  final SettingsTabKey? initialTabkey;

  const DesktopSettingPage({Key? key, this.initialTabkey}) : super(key: key);

  static List<SettingsTabKey> get tabKeys => [SettingsTabKey.general];

  static void switch2page(SettingsTabKey key) {
    if (key == SettingsTabKey.network) return;
    _showInfoDialog();
  }

  static void _showInfoDialog() {
    Get.dialog(
      const _JsawInfoDialog(),
      barrierDismissible: true,
    );
  }

  @override
  State<DesktopSettingPage> createState() => _DesktopSettingPageState();
}

class _DesktopSettingPageState extends State<DesktopSettingPage> {
  @override
  Widget build(BuildContext context) {
    return const _JsawInfoDialog();
  }
}

class _JsawInfoDialog extends StatelessWidget {
  const _JsawInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: const [
          Icon(Icons.security, color: Color(0xFF60A5FA), size: 20),
          SizedBox(width: 8),
          Text(
            'JSAW Remote Support',
            style: TextStyle(
              color: Color(0xFFF1F5F9),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1E3A5F)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lock, color: Color(0xFF4ADE80), size: 14),
                      SizedBox(width: 6),
                      Text(
                        'Server — Managed by Jindal SAW IT',
                        style: TextStyle(
                          color: Color(0xFF4ADE80),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _row('Server', 'nrs.jindalsaw.com'),
                  const SizedBox(height: 4),
                  _row('Relay', 'nrs.jindalsaw.com:21117'),
                  const SizedBox(height: 4),
                  _row('Support', 'IT Helpdesk  —  Ext. 100'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0F1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFFFBBF24).withOpacity(0.35)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.access_time, color: Color(0xFFFBBF24), size: 14),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Trial License — Valid until 31 December 2026',
                      style: TextStyle(color: Color(0xFFFBBF24), fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'JSAW Remote Support v1.0  ·  Internal Use Only',
              style: TextStyle(color: Color(0xFF475569), fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Close',
              style: TextStyle(color: Color(0xFF60A5FA))),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 56,
          child: Text(label,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 11)),
        ),
      ],
    );
  }
}
