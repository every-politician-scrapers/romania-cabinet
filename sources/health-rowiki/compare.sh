#!/bin/bash

cd sources/health-rowiki/

bundle exec ruby scraper.rb | ifne tee scraped.csv
wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | ifne tee wikidata.csv
bundle exec ruby diff.rb | tee diff.csv

cd -
