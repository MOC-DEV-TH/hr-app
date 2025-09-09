import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../api/firebase_api.dart';
import '../../../common_widgets/custom_app_bar_view.dart';
import '../../../utils/colors.dart';

class SettingPage extends StatefulWidget {
  final VoidCallback? onOpenSettings;
  const SettingPage({super.key, this.onOpenSettings});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with WidgetsBindingObserver {
  PermissionStatus _status = PermissionStatus.denied;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshStatus();
    }
  }

  Future<void> _refreshStatus() async {
    final s = await Permission.notification.status;
    if (!mounted) return;
    setState(() => _status = s);
  }

  Future<void> _requestAndInit() async {
    setState(() => _busy = true);
    try {
      final result = await Permission.notification.request();

      if (result.isGranted) {
        await FirebaseApi().initNotification();
        await FirebaseApi.scheduleDailyCheckInCheckOutNotification();
        await _refreshStatus();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications enabled ✔')),
        );
      } else if (result.isPermanentlyDenied) {
        final opened = await openAppSettings();
        if (!opened && widget.onOpenSettings != null) widget.onOpenSettings!();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openSettings() async {
    final opened = await openAppSettings();
    if (!opened && widget.onOpenSettings != null) widget.onOpenSettings!();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOn = _status.isGranted;
    final bg = theme.brightness == Brightness.dark
        ? const Color(0xFF1C1C1E)
        : Colors.white;

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const CustomAppBarView(title: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: isOn
              ? _EnabledCard(
            key: const ValueKey('enabled'),
            bg: bg,
            onManage: _openSettings,
            onReschedule: () async {
              setState(() => _busy = true);
              try {
                await FirebaseApi.scheduleDailyCheckInCheckOutNotification();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Daily reminders scheduled')),
                );
              } finally {
                if (mounted) setState(() => _busy = false);
              }
            },
          )
              : _DisabledCard(
            key: const ValueKey('disabled'),
            bg: bg,
            busy: _busy,
            onEnable: _requestAndInit,
          ),
        ),
      ),
    );
  }
}

class _EnabledCard extends StatelessWidget {
  final Color bg;
  final VoidCallback onManage;
  final VoidCallback onReschedule;

  const _EnabledCard({
    super.key,
    required this.bg,
    required this.onManage,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 6),
            ),
        ],
        border: Border.all(color: const Color(0xFF34C759).withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF34C759), // iOS system green
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.notifications_active, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Notifications On',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(Icons.check_circle, color: Color(0xFF34C759)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'You’ll receive reminders and messages right away.',
            style: theme.textTheme.titleMedium?.copyWith(height: 1.35),
          ),
          const SizedBox(height: 12),
          // quick actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onManage,
                  icon: const Icon(Icons.settings),
                  label: const Text('Manage in Settings'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Visibility(
                  visible: false,
                  child: FilledButton.icon(
                    onPressed: onReschedule,
                    icon: const Icon(Icons.alarm),
                    label: const Text('Reschedule Daily'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color(0xFF34C759),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // subtle info
          Text(
            'Tip: You can fine-tune channels & sounds inside system settings.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisabledCard extends StatelessWidget {
  final Color bg;
  final bool busy;
  final VoidCallback onEnable;

  const _DisabledCard({
    super.key,
    required this.bg,
    required this.busy,
    required this.onEnable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _WarningDot(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Turn ON Notifications',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Don't miss important messages from your friends and coworkers.",
            style: theme.textTheme.titleMedium?.copyWith(height: 1.35),
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            thickness: 0.5,
            color: theme.dividerColor.withOpacity(0.6),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.centerLeft,
            ),
            onPressed: busy ? null : onEnable,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  busy ? 'Enabling…' : 'Turn ON Notification',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0A84FF),
                  ),
                ),
                if (busy) const SizedBox(width: 10),
                if (busy)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningDot extends StatelessWidget {
  const _WarningDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFFF3B30), // iOS system red
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.priority_high, color: Colors.white, size: 22),
    );
  }
}
