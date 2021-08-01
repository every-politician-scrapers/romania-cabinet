#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'
require 'pry'

# Process the data from each source before comparison
class Comparison < EveryPoliticianScraper::Comparison
  def wikidata_csv_options
    { converters: [->(val) { val.to_s.downcase }] }
  end

  def external_csv_options
    { converters: [->(val) { val.to_s.downcase }] }
  end
end

diff = Comparison.new('data/wikidata.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
