import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/enums.dart';
import '../theme/app_theme.dart';
import '../utils/dates.dart';
import '../utils/money.dart';
import '../utils/quantity.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.helper,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.required = false,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.capitalization = TextCapitalization.sentences,
    this.inputFormatters,
    this.autofocus = false,
    this.textInputAction,
    this.maxLength,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? helper;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool required;
  final String? Function(String)? validator;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final TextCapitalization capitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final int? maxLength;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Gap.md),
    child: TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType:
          keyboardType ??
          (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      textCapitalization: capitalization,
      inputFormatters: inputFormatters,
      textInputAction:
          textInputAction ??
          (maxLines == 1 ? TextInputAction.next : TextInputAction.newline),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        helperText: helper,
        helperMaxLines: 3,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        alignLabelWithHint: maxLines != 1,
      ),
      validator: (v) {
        final value = v ?? '';
        if (required && value.trim().isEmpty) return '$label is required';
        return validator?.call(value);
      },
    ),
  );
}

/// Amount input in rupees; validates without floating point.
class MoneyField extends StatelessWidget {
  const MoneyField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.required = false,
    this.helper,
    this.allowZero = true,
    this.max,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<int>? onChanged;
  final bool required;
  final String? helper;
  final bool allowZero;
  final int? max;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Gap.md),
    child: TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        prefixText: '₹ ',
        helperText: helper,
        helperMaxLines: 2,
      ),
      onChanged: (v) => onChanged?.call(Money.tryParse(v) ?? 0),
      validator: (v) {
        try {
          final p = Money.parse(v ?? '');
          if (p == null) return required ? '$label is required' : null;
          if (p < 0) return 'Cannot be negative';
          if (!allowZero && p == 0) return 'Must be more than zero';
          if (max != null && p > max!) {
            return 'Cannot be more than ${Money.format(max!)}';
          }
          return null;
        } on FormatException catch (e) {
          return e.message;
        }
      },
    ),
  );
}

class QtyField extends StatelessWidget {
  const QtyField({
    super.key,
    required this.controller,
    this.label = 'Quantity',
    this.unit,
    this.onChanged,
    this.allowNegative = false,
  });
  final TextEditingController controller;
  final String label;
  final String? unit;
  final ValueChanged<int>? onChanged;
  final bool allowNegative;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Gap.md),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: allowNegative,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(allowNegative ? r'[0-9.\-]' : r'[0-9.]'),
        ),
      ],
      decoration: InputDecoration(labelText: '$label *', suffixText: unit),
      onChanged: (v) => onChanged?.call(Qty.tryParse(v) ?? 0),
      validator: (v) {
        try {
          final q = Qty.parse(v ?? '');
          if (q == null) return '$label is required';
          if (q == 0) return 'Cannot be zero';
          if (!allowNegative && q < 0) return 'Must be more than zero';
          return null;
        } on FormatException catch (e) {
          return e.message;
        }
      },
    ),
  );
}

/// Tappable date field holding an ISO date string.
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.allowClear = false,
    this.required = false,
    this.firstDate,
    this.lastDate,
    this.helper,
  });
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool allowClear;
  final bool required;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final has = value != null && value!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final initial = Dates.tryParse(value) ?? Dates.todayDate();
          final picked = await showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: firstDate ?? DateTime(2000),
            lastDate: lastDate ?? DateTime(2100),
            helpText: label,
          );
          if (picked != null) onChanged(Dates.iso(picked));
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: required ? '$label *' : label,
            helperText: helper,
            prefixIcon: const Icon(Icons.calendar_today_outlined),
            suffixIcon: allowClear && has
                ? IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.clear),
                    onPressed: () => onChanged(null),
                  )
                : null,
          ),
          isEmpty: !has,
          child: Text(
            has ? Dates.display(value) : '',
            style: context.text.bodyLarge,
          ),
        ),
      ),
    );
  }
}

/// Tappable time field holding "HH:mm".
class TimeField extends StatelessWidget {
  const TimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final has = value != null && value!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          TimeOfDay initial = TimeOfDay.now();
          if (has) {
            final p = value!.split(':');
            initial = TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
          }
          final t = await showTimePicker(
            context: context,
            initialTime: initial,
            helpText: label,
          );
          if (t != null) {
            onChanged(
              '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
            );
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.schedule),
            suffixIcon: has
                ? IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.clear),
                    onPressed: () => onChanged(null),
                  )
                : null,
          ),
          isEmpty: !has,
          child: Text(
            has ? Dates.displayTime(value) : '',
            style: context.text.bodyLarge,
          ),
        ),
      ),
    );
  }
}

/// Dropdown for one of our [Labeled] enums.
class EnumDropdown<T extends Labeled> extends StatelessWidget {
  const EnumDropdown({
    super.key,
    required this.label,
    required this.values,
    required this.value,
    required this.onChanged,
    this.allowNone = false,
    this.noneLabel = 'Not set',
  });
  final String label;
  final List<T> values;
  final T? value;
  final ValueChanged<T?> onChanged;
  final bool allowNone;
  final String noneLabel;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Gap.md),
    child: DropdownButtonFormField<T?>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        if (allowNone)
          DropdownMenuItem<T?>(value: null, child: Text(noneLabel)),
        for (final v in values)
          DropdownMenuItem<T?>(value: v, child: Text(v.label)),
      ],
      onChanged: onChanged,
    ),
  );
}

/// Segmented single choice with large touch targets.
class ChoiceChips<T> extends StatelessWidget {
  const ChoiceChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.labelOf,
  });
  final List<T> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final String Function(T) labelOf;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: Gap.sm,
    runSpacing: Gap.sm,
    children: [
      for (final o in options)
        ChoiceChip(
          label: Text(labelOf(o)),
          selected: o == selected,
          onSelected: (_) => onSelected(o),
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
    ],
  );
}

/// Title row used to break long forms into readable steps.
class FormStepHeader extends StatelessWidget {
  const FormStepHeader(this.letter, this.title, {super.key, this.subtitle});
  final String letter;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Gap.md),
    child: Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: context.colors.primary,
          child: Text(
            letter,
            style: TextStyle(
              color: context.colors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: Gap.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.text.titleMedium),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
