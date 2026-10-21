import 'package:flutter/material.dart';

import '../../domain/enums.dart';
import '../theme/app_theme.dart';

enum Tone { success, warning, danger, info, neutral }

Tone paymentTone(PaymentStatus s) => switch (s) {
  PaymentStatus.paid => Tone.success,
  PaymentStatus.partiallyPaid => Tone.warning,
  PaymentStatus.overdue => Tone.danger,
  PaymentStatus.unpaid => Tone.info,
  PaymentStatus.cancelled => Tone.neutral,
};

Tone visitTone(VisitStatus s) => switch (s) {
  VisitStatus.completed => Tone.success,
  VisitStatus.inProgress => Tone.warning,
  VisitStatus.scheduled => Tone.info,
  VisitStatus.cancelled => Tone.neutral,
};

Tone machineTone(MachineStatus s) => switch (s) {
  MachineStatus.operational => Tone.success,
  MachineStatus.needsAttention => Tone.warning,
  MachineStatus.underRepair => Tone.danger,
  MachineStatus.decommissioned => Tone.neutral,
};

class StatusChip extends StatelessWidget {
  const StatusChip(this.label, this.tone, {super.key, this.icon});

  factory StatusChip.payment(PaymentStatus s) =>
      StatusChip(s.label, paymentTone(s));
  factory StatusChip.visit(VisitStatus s) => StatusChip(s.label, visitTone(s));
  factory StatusChip.machine(MachineStatus s) =>
      StatusChip(s.label, machineTone(s));

  final String label;
  final Tone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final s = context.status;
    final (bg, fg) = switch (tone) {
      Tone.success => (s.success, s.onSuccess),
      Tone.warning => (s.warning, s.onWarning),
      Tone.danger => (s.danger, s.onDanger),
      Tone.info => (s.info, s.onInfo),
      Tone.neutral => (s.neutral, s.onNeutral),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
