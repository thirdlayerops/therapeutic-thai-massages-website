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
sed "s|<meta charset=\"utf-8\">|<meta charset=\"utf-8\">\n<title>$TITLE</title>\n<meta name=\"description\" content=\"$DESC\">|" "$SRC" > public/page.tmp

# Online booking: insert booking-section.html (the Setmore calendar) on the
# Book Now page, right under its heading. The build stops with an error if
# the design file changes so much that the insertion point can't be found,
# so the calendar can never silently disappear from the live site.
awk -v blockfile="booking-section.html" '
  BEGIN { while ((getline line < blockfile) > 0) block = block line "\n" }
  { print }
  /sc-if value="\{\{ pageContact \}\}"/ { incontact = 1 }
  incontact && /<\/section>/ && !done { printf "%s", block; done = 1 }
  END { if (!done) { print "build.sh: could not find the Book Now page to insert the booking calendar" > "/dev/stderr"; exit 3 } }
' public/page.tmp > public/index.html
rm public/page.tmp

# The Book Now page heading.
sed -i.bak 's|>Call us now</h1>|>Book a session</h1>|' public/index.html && rm public/index.html.bak

# Page runtime, pointed at local copies of its libraries instead of unpkg.com.
sed -e 's|https://unpkg.com/react@18.3.1/umd/react.production.min.js|/vendor/react.production.min.js|' \
    -e 's|https://unpkg.com/react-dom@18.3.1/umd/react-dom.production.min.js|/vendor/react-dom.production.min.js|' \
    -e 's|https://unpkg.com/@babel/standalone@7.29.0/babel.min.js|/vendor/babel.min.js|' \
    support.js > public/support.js

cp image-slot.js public/
cp vendor/*.js public/vendor/
cp -r images public/images

echo "Built public/ ($(find public -type f | wc -l) files)"
