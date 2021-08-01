#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      noko.css('h3').text.tidy
    end

    field :position do
      noko.css('p').text.tidy
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      container.map { |member| fragment(member => Member).to_h }
    end

    private

    def container
      noko.css('#page .ministriiDescriere')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
