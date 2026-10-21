#!/usr/bin/env bash
# Applies the migrations to a throw-away database on a local PostgreSQL server
# and runs the RLS / sync / integrity assertions in schema_test.sql.
# Usage: supabase/tests/run_schema_tests.sh   (needs psql + a local server)
set -euo pipefail
cd "$(dirname "$0")"
DB="service_register_schema_test_$$"
createdb "$DB"
trap 'dropdb --if-exists "$DB"' EXIT
psql -X -q -v ON_ERROR_STOP=1 -d "$DB" -f auth_stub.sql
psql -X -q -v ON_ERROR_STOP=1 -d "$DB" -f ../migrations/20261016000000_initial_schema.sql
# (Storage migration needs Supabase's storage schema; it is not applied here.)
psql -X -q -v ON_ERROR_STOP=1 -d "$DB" -f schema_test.sql
