#!/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'pry'
require 'scraped'
require 'table_unspanner'
require 'wikidata_ids_decorator'

require 'open-uri/cached'

class RomanianDate
  REMAP = {
    'prezent'    => '',
    'ianuarie'   => 'January',
    'februarie'  => 'February',
    'martie'     => 'March',
    'aprilie'    => 'April',
    'mai'        => 'May',
    'iunie'      => 'June',
    'iulie'      => 'July',
    'august'     => 'August',
    'septembrie' => 'September',
    'octombrie'  => 'October',
    'noiembrie'  => 'November',
    'decembrie'  => 'December',
  }.freeze

  def initialize(date_str)
    @date_str = date_str
  end

  def to_s
    return if date_en.to_s.empty?

    date_obj.to_s
  end

  private

  attr_reader :date_str

  def date_obj
    @date_obj ||= Date.parse(date_en) rescue ''
  end

  def date_en
    @date_en ||= REMAP.reduce(date_str) { |str, (ro, en)| str.sub(ro, en) }
  end
end

class RemoveReferences < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('sup.reference').remove
    end.to_s
  end
end

class UnspanAllTables < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('table.wikitable').each do |table|
        unspanned_table = TableUnspanner::UnspannedTable.new(table)
        table.children = unspanned_table.nokogiri_node.children
      end
    end.to_s
  end
end

class MinistersList < Scraped::HTML
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  field :ministers do
    member_entries.map { |ul| fragment(ul => Officeholder).to_h }
  end

  private

  def member_entries
    noko.xpath('//table[.//th[contains(.,"Mandat")]]//tr[td]')
  end
end

class Officeholder < Scraped::HTML
  field :item do
    tds[0].css('a/@wikidata').first
  end

  field :itemLabel do
    tds[0].text.tidy
  end

  field :startDate do
    RomanianDate.new(tds[1].text.tidy).to_s
  end

  field :endDate do
    RomanianDate.new(tds[2].text.tidy).to_s
  end

  private

  def tds
    noko.css('td')
  end
end

url = 'https://ro.wikipedia.org/wiki/Ministerul_Agriculturii_%C8%99i_Dezvolt%C4%83rii_Rurale_(Rom%C3%A2nia)'
data = MinistersList.new(response: Scraped::Request.new(url: url).response).ministers

header = data.first.keys.to_csv
rows = data.map { |row| row.values.to_csv }
abort 'No results' if rows.count.zero?

puts header + rows.join
