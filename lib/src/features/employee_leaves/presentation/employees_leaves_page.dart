import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class EmployeesLeavesPage extends StatefulWidget {
  const EmployeesLeavesPage({super.key});

  @override
  State<EmployeesLeavesPage> createState() => _EmployeesLeavesPageState();
}

class _EmployeesLeavesPageState extends State<EmployeesLeavesPage> {
  final List<LeaveRequest> _requests = [
    LeaveRequest(
      name: 'Aye Aye',
      role: 'Backend Developer',
      type: 'Sick',
      remainingDays: 1,
      message:
      "Hello, I'm not feeling well and need to request 2 days of sick leave. Thank you for understanding.",
      status: LeaveStatus.pending,
    ),
    LeaveRequest(
      name: 'Aung Aung',
      role: 'Backend Developer',
      type: 'Sick',
      remainingDays: 0,
      message:
      "Hello, I'm not feeling well and need to request 2 days of sick leave. Thank you for understanding.",
      status: LeaveStatus.approved,
    ),
    LeaveRequest(
      name: 'Mg Mg',
      role: 'Backend Developer',
      type: 'Sick',
      remainingDays: 0,
      message:
      "Hello, I'm not feeling well and need to request 2 days of sick leave. Thank you for understanding.",
      status: LeaveStatus.approved,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final count = _requests.length;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Text('Leave ($count)'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        itemBuilder: (_, i) => _LeaveCard(
          req: _requests[i],
          onApprove: () => setState(() {
            _requests[i] = _requests[i].copyWith(status: LeaveStatus.approved);
          }),
          onReject: () => setState(() {
            _requests[i] = _requests[i].copyWith(status: LeaveStatus.rejected);
          }),
        ),
        separatorBuilder: (_, __) => Divider(
          height: 24,
          thickness: 1,
          color: cs.outlineVariant,
        ),
        itemCount: _requests.length,
      ),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  const _LeaveCard({
    required this.req,
    this.onApprove,
    this.onReject,
  });

  final LeaveRequest req;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    Widget _statusChip(LeaveStatus s) {
      final text = s == LeaveStatus.approved
          ? 'Approved'
          : s == LeaveStatus.rejected
          ? 'Rejected'
          : 'Pending';
      final color = s == LeaveStatus.approved
          ? Colors.grey
          : s == LeaveStatus.rejected
          ? Colors.red
          : cs.primary;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: tt.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w600)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const CircleAvatar(
              radius: 20,
              child: Icon(Icons.person_outline),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(req.name,
                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text(req.role, style: tt.bodySmall?.copyWith(color: cs.outline)),
                ],
              ),
            ),
            if (req.status != LeaveStatus.pending) _statusChip(req.status),
          ],
        ),
        const SizedBox(height: 14),

        // Details
        _LabelValue(label: 'Leave Type:', value: req.type),
        if (req.status == LeaveStatus.pending) ...[
          const SizedBox(height: 6),
          _LabelValue(label: 'Remaining:', value: '${req.remainingDays}'),
        ],
        const SizedBox(height: 10),
        Text('Message:', style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(req.message, style: tt.bodyMedium),

        const SizedBox(height: 14),

        // Actions
        if (req.status == LeaveStatus.pending)
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE96464),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onReject,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close, size: 18),
                      SizedBox(width: 6),
                      Text('Reject'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3DBE68),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onApprove,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, size: 18),
                      SizedBox(width: 6),
                      Text('Approve'),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            )),
        const SizedBox(width: 6),
        Expanded(child: Text(value, style: tt.bodyMedium)),
      ],
    );
  }
}

/// Simple model
enum LeaveStatus { pending, approved, rejected }

class LeaveRequest {
  final String name;
  final String role;
  final String type;
  final int remainingDays;
  final String message;
  final LeaveStatus status;

  const LeaveRequest({
    required this.name,
    required this.role,
    required this.type,
    required this.remainingDays,
    required this.message,
    required this.status,
  });

  LeaveRequest copyWith({LeaveStatus? status}) =>
      LeaveRequest(
        name: name,
        role: role,
        type: type,
        remainingDays: remainingDays,
        message: message,
        status: status ?? this.status,
      );
}
