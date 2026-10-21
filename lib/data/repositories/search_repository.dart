import 'package:drift/drift.dart';

import '../local/app_database.dart';

enum SearchKind { company, machine, visit, invoice, part }

class SearchResult {
  const SearchResult(this.kind, this.id, this.title, this.subtitle);
  final SearchKind kind;
  final String id;
  final String title;
  final String subtitle;
}

/// Global search across the main record types.
class SearchRepository {
  SearchRepository(this.db);
  final AppDatabase db;

  Future<List<SearchResult>> search(String query, {int perKind = 15}) async {
    final q = query.trim().toLowerCase();
    if (q.length < 2) return const [];
    final like = Variable.withString('%$q%');
    final digits = q.replaceAll(RegExp(r'\D'), '');
    final phoneLike = Variable.withString(
      digits.length >= 3 ? '%$digits%' : '\u0000',
    );

    Future<List<SearchResult>> run(
      SearchKind kind,
      String sql,
      List<Variable<Object>> vars,
    ) async {
      final rows = await db
          .customSelect('$sql LIMIT $perKind', variables: vars)
          .get();
      return [
        for (final r in rows)
          SearchResult(
            kind,
            r.read<String>('id'),
            r.read<String>('title'),
            r.readNullable<String>('subtitle') ?? '',
          ),
      ];
    }

    String l(String col) => "LOWER(COALESCE($col, '')) LIKE ?1";
    String ph(String col) =>
        "REPLACE(REPLACE(COALESCE($col, ''), ' ', ''), '-', '') LIKE ?2";

    final results = await Future.wait([
      run(
        SearchKind.company,
        "SELECT id, name AS title, TRIM(COALESCE(code, '') || '  ' || COALESCE(phone, '') "
        "|| '  ' || COALESCE(city, '')) AS subtitle FROM companies "
        "WHERE ${l('name')} OR ${l('code')} OR ${l('contact_person')} "
        'OR ${ph('phone')} OR ${ph('alt_phone')} ORDER BY archived_at IS NOT NULL, name',
        [like, phoneLike],
      ),
      run(
        SearchKind.machine,
        "SELECT m.id, m.name AS title, c.name || COALESCE('  •  S/N ' || m.serial_number, '') "
        'AS subtitle FROM machines m JOIN companies c ON c.id = m.company_id '
        "WHERE ${l('m.name')} OR ${l('m.serial_number')} OR ${l('m.model')} "
        "OR ${l('m.manufacturer')} ORDER BY m.name",
        [like],
      ),
      run(
        SearchKind.visit,
        "SELECT v.id, v.visit_no || '  •  ' || c.name AS title, "
        "v.visit_date || '  ' || COALESCE(v.reported_problem, v.work_done, '') AS subtitle "
        'FROM service_visits v JOIN companies c ON c.id = v.company_id '
        "WHERE v.archived_at IS NULL AND (${l('v.visit_no')} OR ${l('v.reported_problem')} "
        "OR ${l('v.diagnosis')} OR ${l('v.work_done')} OR ${l('v.symptoms')}) "
        'ORDER BY v.visit_date DESC',
        [like],
      ),
      run(
        SearchKind.invoice,
        "SELECT i.id, i.invoice_no AS title, c.name || '  •  ' || i.invoice_date AS subtitle "
        'FROM invoices i JOIN companies c ON c.id = i.company_id '
        "WHERE ${l('i.invoice_no')} ORDER BY i.invoice_date DESC",
        [like],
      ),
      run(
        SearchKind.part,
        "SELECT id, name AS title, COALESCE(part_number, '') AS subtitle FROM parts "
        "WHERE ${l('name')} OR ${l('part_number')} ORDER BY name",
        [like],
      ),
    ]);
    return results.expand((r) => r).toList();
  }
}
