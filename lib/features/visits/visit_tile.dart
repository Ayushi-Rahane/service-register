import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/repositories/visit_repository.dart';
import '../../domain/enums.dart';

class VisitTile extends StatelessWidget {
  const VisitTile(
    this.item, {
    super.key,
    this.showCompany = true,
    this.relativeDate = false,
  });
  final VisitListItem item;
  final bool showCompany;
  final bool relativeDate;

  @override
  Widget build(BuildContext context) {
    final v = item.visit;
    final status = VisitStatus.fromDb(v.status);
    final missed =
        status == VisitStatus.scheduled &&
        v.visitDate.compareTo(Dates.today()) < 0;
    final when = relativeDate
        ? Dates.relative(v.visitDate)
        : Dates.display(v.visitDate);
    final time = v.arrivalTime == null
        ? ''
        : ' • ${Dates.displayTime(v.arrivalTime)}';
    final title = showCompany
        ? item.companyName
        : (item.machineName ?? ServiceType.fromDb(v.serviceType).label);
    final detail = [
      if (showCompany && item.machineName != null) item.machineName!,
      if (v.reportedProblem != null) v.reportedProblem!,
    ].join(' • ');
    return ListTile(
      onTap: () => context.push('/visit/${v.id}'),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$when$time  •  ${v.visitNo}', style: context.text.bodySmall),
          if (detail.isNotEmpty)
            Text(detail, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          missed
              ? const StatusChip('Missed', Tone.danger)
              : StatusChip.visit(status),
          if (v.totalPaise > 0) ...[
            const SizedBox(height: 4),
            Text(Money.short(v.totalPaise), style: context.text.labelMedium),
          ],
        ],
      ),
    );
  }
}
