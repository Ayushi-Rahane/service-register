import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';

/// Renders an [AsyncValue] with consistent loading and error states.
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({
    super.key,
    required this.value,
    required this.builder,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => value.when(
    data: builder,
    loading: () => const LoadingView(),
    error: (e, _) => ErrorView(message: '$e', onRetry: onRetry),
  );
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(Gap.xl),
      child: CircularProgressIndicator(),
    ),
  );
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Gap.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: context.colors.error),
          const SizedBox(height: Gap.md),
          Text('Something went wrong', style: context.text.titleMedium),
          const SizedBox(height: Gap.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: Gap.lg),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ],
      ),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(Gap.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: context.colors.primaryContainer,
            child: Icon(
              icon,
              size: 36,
              color: context.colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: Gap.lg),
          Text(
            title,
            style: context.text.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: Gap.sm),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: Gap.lg),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    ),
  );
}

/// White card with an optional title row.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    this.icon,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(Gap.lg),
  });
  final String? title;
  final IconData? icon;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: context.colors.primary),
                  const SizedBox(width: Gap.sm),
                ],
                Expanded(child: Text(title!, style: context.text.titleMedium)),
                ?trailing,
              ],
            ),
            const SizedBox(height: Gap.md),
          ],
          child,
        ],
      ),
    ),
  );
}

/// Label above value, used on detail screens. Hidden when value is empty
/// unless [showEmpty].
class InfoRow extends StatelessWidget {
  const InfoRow(
    this.label,
    this.value, {
    super.key,
    this.showEmpty = false,
    this.trailing,
  });
  final String label;
  final String? value;
  final bool showEmpty;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final v = value?.trim() ?? '';
    if (v.isEmpty && !showEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Gap.xs + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.text.labelMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(v.isEmpty ? '-' : v, style: context.text.bodyLarge),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// A two-column "label .... amount" line.
class AmountLine extends StatelessWidget {
  const AmountLine(
    this.label,
    this.amount, {
    super.key,
    this.bold = false,
    this.color,
  });
  final String label;
  final String amount;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = (bold ? context.text.titleMedium : context.text.bodyLarge)
        ?.copyWith(color: color);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            amount,
            style: style?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class KpiTile extends StatelessWidget {
  const KpiTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
    this.color,
    this.onTap,
  });
  final String label;
  final String value;
  final IconData icon;
  final String? caption;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.colors.primary;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Gap.md + 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: c),
                  const SizedBox(width: Gap.sm),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 2,
                      style: context.text.labelLarge?.copyWith(
                        fontSize: 14,
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Gap.sm),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: context.text.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: c,
                  ),
                ),
              ),
              if (caption != null)
                Text(
                  caption!,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small heading above a group in a list.
class ListHeader extends StatelessWidget {
  const ListHeader(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.sm, Gap.sm),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelMedium?.copyWith(
              letterSpacing: 0.8,
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        // The action shrinks instead of overflowing on narrow phones.
        if (trailing != null)
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: trailing,
            ),
          ),
      ],
    ),
  );
}

/// Banner for warnings inside forms/detail screens.
class NoticeBanner extends StatelessWidget {
  const NoticeBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.danger = false,
  });
  final String message;
  final IconData icon;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final bg = danger ? context.status.danger : context.status.warning;
    final fg = danger ? context.status.onDanger : context.status.onWarning;
    return Container(
      padding: const EdgeInsets.all(Gap.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: Gap.sm),
          Expanded(
            child: Text(
              message,
              style: context.text.bodyMedium?.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sticky bottom area for a form's primary action, always visible above the
/// keyboard / system bar.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
    elevation: 8,
    color: context.colors.surface,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.sm),
        child: child,
      ),
    ),
  );
}
