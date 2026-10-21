#!/usr/bin/env bash
# Builds the website (same app, runs in the browser) and zips it for upload
# to a static host such as Netlify Drop or Cloudflare Pages.
#   tool/build_web.sh            -> build/web/ and build/ServiceRegister-website.zip
set -euo pipefail
cd "$(dirname "$0")/.."
flutter build web --release --dart-define-from-file=env/prod.json --no-web-resources-cdn
rm -f build/ServiceRegister-website.zip
(cd build/web && zip -qr ../ServiceRegister-website.zip .)
echo "Website ready: build/web  (zip: build/ServiceRegister-website.zip)"
