#!/bin/sh
# Assembles the deployable site in ./public from the design source files.
# Cloudflare runs this automatically before every deploy (see wrangler.jsonc).
set -e

SRC="Therapeutic Thai Massages.dc.html"
TITLE="Serenity Therapeutic Massage \\&amp; Spa"
DESC="Traditional Thai bodywork that stretches, presses and restores."

rm -rf public
mkdir -p public/vendor

# Home page: the design source, with a page title and description added.
sed "s|<meta charset=\"utf-8\">|<meta charset=\"utf-8\">\n<title>$TITLE</title>\n<meta name=\"description\" content=\"$DESC\">|" "$SRC" > public/index.html

# Page runtime, pointed at local copies of its libraries instead of unpkg.com.
sed -e 's|https://unpkg.com/react@18.3.1/umd/react.production.min.js|/vendor/react.production.min.js|' \
    -e 's|https://unpkg.com/react-dom@18.3.1/umd/react-dom.production.min.js|/vendor/react-dom.production.min.js|' \
    -e 's|https://unpkg.com/@babel/standalone@7.29.0/babel.min.js|/vendor/babel.min.js|' \
    support.js > public/support.js

cp image-slot.js public/
cp vendor/*.js public/vendor/
cp -r images public/images

echo "Built public/ ($(find public -type f | wc -l) files)"
