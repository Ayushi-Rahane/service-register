import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;

import '../support/test_db.dart';

void main() {
  test(
    'rows pushed to the server use ISO-8601 UTC timestamps and plain ints',
    () async {
      final env = TestEnv();
      final id = await env.addCompany('Shree');
      final row =
          (await env.db
                  .customSelect(
                    'SELECT * FROM companies WHERE id = ?',
                    variables: [Variable.withString(id)],
                  )
                  .getSingle())
              .data;
      expect(
        row['created_at'],
        matches(RegExp(r'^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d(\.\d+)?Z$')),
      );
      expect(DateTime.parse(row['created_at'] as String).isUtc, isTrue);
      expect(row['server_rev'], 0);
      await env.close();
    },
  );
}
