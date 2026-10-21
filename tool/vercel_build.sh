#!/usr/bin/env bash
# Build command for Vercel (configured in vercel.json). Vercel has no Flutter,
# so this installs the same Flutter version used for development, writes the
# cloud settings from Vercel environment variables (never committed), and
# builds the website into build/web.
set -euo pipefail
FLUTTER_VERSION="3.41.6"

if ! command -v flutter >/dev/null 2>&1; then
  FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"
  if [ ! -x "$FLUTTER_HOME/bin/flutter" ]; then
    git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_HOME"
  fi
  export PATH="$FLUTTER_HOME/bin:$PATH"
fi
flutter --version
flutter config --no-analytics --enable-web >/dev/null

: "${SUPABASE_URL:?Set SUPABASE_URL in Vercel → Project → Settings → Environment Variables}"
: "${SUPABASE_ANON_KEY:?Set SUPABASE_ANON_KEY in Vercel → Project → Settings → Environment Variables}"
mkdir -p env
printf '{\n  "SUPABASE_URL": "%s",\n  "SUPABASE_ANON_KEY": "%s"\n}\n' "$SUPABASE_URL" "$SUPABASE_ANON_KEY" > env/prod.json

flutter pub get
flutter build web --release --dart-define-from-file=env/prod.json --no-web-resources-cdn
