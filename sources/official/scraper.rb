#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    field :name do
      noko.css('h3').text.tidy
    end

    field :position do
      noko.css('p').text.tidy.split(/, (?=Minister)/i)
    end
  end

  class Members
    def member_container
      noko.css('#page .ministriiDescriere')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
