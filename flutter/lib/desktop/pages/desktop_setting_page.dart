import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/common/widgets/setting_widgets.dart';
import 'package:flutter_hbb/desktop/pages/account_page.dart';
import 'package:flutter_hbb/desktop/pages/display_page.dart';
import 'package:flutter_hbb/desktop/pages/general_page.dart';
import 'package:flutter_hbb/desktop/pages/security_page.dart';
import 'package:flutter_hbb/desktop/pages/server_page.dart';
import 'package:get/get.dart';

const kNavGeneral = "General";
const kNavSecurity = "Security";
const kNavNetwork = "Network";
const kNavDisplay = "Display";
const kNavAccount = "Account";

class DesktopSettingPage extends StatefulWidget {
  final String? initialNav;
  const DesktopSettingPage({Key? key, this.initialNav}) : super(key: key);

  @override
  State<DesktopSettingPage> createState() => _DesktopSettingPageState();
}

class _DesktopSettingPageState extends State<DesktopSettingPage> {
  late String _selectedNav;

  @override
  void initState() {
    super.initState();
    // Default to General tab, preventing load of hidden Network tab
    _selectedNav = (widget.initialNav != null && widget.initialNav != kNavNetwork)
        ? widget.initialNav!
        : kNavGeneral;
  }

  void _updateNav(String nav) {
    setState(() {
      _selectedNav = nav;
    });
  }

  Widget _buildItem(
    BuildContext context,
    String key,
    IconData icon,
    String title, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final color = selected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: selected ? theme.colorScheme.primary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: color, size: 18),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Navigation Drawer
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildItem(
                  context,
                  kNavGeneral,
                  Icons.settings_outlined,
                  translate("General"),
                  selected: _selectedNav == kNavGeneral,
                  onTap: () => _updateNav(kNavGeneral),
                ),
                _buildItem(
                  context,
                  kNavSecurity,
                  Icons.security_outlined,
                  translate("Security"),
                  selected: _selectedNav == kNavSecurity,
                  onTap: () => _updateNav(kNavSecurity),
                ),
                // Note: kNavNetwork (Network Settings) has been removed here to lock down configuration
                _buildItem(
                  context,
                  kNavDisplay,
                  Icons.desktop_windows_outlined,
                  translate("Display"),
                  selected: _selectedNav == kNavDisplay,
                  onTap: () => _updateNav(kNavDisplay),
                ),
                _buildItem(
                  context,
                  kNavAccount,
                  Icons.person_outline,
                  translate("Account"),
                  selected: _selectedNav == kNavAccount,
                  onTap: () => _updateNav(kNavAccount),
                ),
              ],
            ),
          ),
          // Right Content Pane
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedNav) {
      case kNavGeneral:
        return const GeneralPage();
      case kNavSecurity:
        return const SecurityPage();
      case kNavDisplay:
        return const DisplayPage();
      case kNavAccount:
        return const AccountPage();
      default:
        return const GeneralPage();
    }
  }
}
