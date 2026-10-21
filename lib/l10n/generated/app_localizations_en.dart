// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Service Register';

  @override
  String get navHome => 'Home';

  @override
  String get navCompanies => 'Companies';

  @override
  String get navVisits => 'Visits';

  @override
  String get navPayments => 'Payments';

  @override
  String get navMore => 'More';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionArchive => 'Archive';

  @override
  String get actionRestore => 'Restore';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionShare => 'Share';

  @override
  String get actionCall => 'Call';

  @override
  String get actionDirections => 'Directions';

  @override
  String get newVisit => 'New service visit';

  @override
  String get saveDraft => 'Save as draft';

  @override
  String get completeVisit => 'Complete visit';

  @override
  String get recordPayment => 'Record payment';

  @override
  String get createInvoice => 'Create invoice';

  @override
  String get scheduleVisit => 'Schedule visit';

  @override
  String get todaysVisits => 'Today\'s visits';

  @override
  String get upcomingVisits => 'Upcoming visits';

  @override
  String get collectedThisMonth => 'Collected this month';

  @override
  String get billedThisMonth => 'Billed this month';

  @override
  String get outstanding => 'Outstanding';

  @override
  String get overdue => 'Overdue';

  @override
  String get syncAllSaved => 'All changes backed up';

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes not backed up yet',
      one: '1 change not backed up yet',
    );
    return '$_temp0';
  }

  @override
  String get localOnly => 'Saved on this phone only';

  @override
  String requiredField(String field) {
    return '$field is required';
  }
}
