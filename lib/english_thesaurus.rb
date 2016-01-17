require "english_thesaurus/version"

require 'nokogiri'
require 'open-uri'
require 'active_support'
require 'active_support/core_ext'

module EnglishThesaurus
  class Thesaurus
    URL = 'http://thesaurus.com/browse/'

    RELEVANCY_MAP = {high: 3, middle: 2, low: 1}

    def initialize(word)
      @url = URI.encode("#{URL}#{word}")
    end

    def synonyms(relevancy:, word_of_speech: nil)
      raise "illegal relevancy. choose from #{RELEVANCY_MAP}" unless RELEVANCY_MAP.include?(relevancy.to_sym)

      filtered_synonyms = all_synonyms
      if word_of_speech
        filtered_synonyms = all_synonyms.reject {|s| s[:word_of_speech] != word_of_speech }
      end

      filtered_synonyms.map {|s| s.slice(:word_of_speech, :description, "#{relevancy}_relevance_list".to_sym) }
    end

    def all_synonyms
      doc.xpath('//div[@class="synonyms"]').map {|synonym|
        filters_block = synonym.xpath('*[@class="filters"]')

        {
          word_of_speech: filters_block.xpath('div[@class="synonym-description"]/em').text,
          description: filters_block.xpath('div[@class="synonym-description"]/strong').text
        }.merge(RELEVANCY_MAP.inject({}) {|hash, (relevant, level)|
          hash.merge!("#{relevant}_relevance_list".to_sym => filters_block.xpath(relevancy_block_xpath_query(relevancy: level)).map(&:text))
        })
      }
    end

    private

    def relevancy_block_xpath_query(relevancy:)
      "div[@class=\"relevancy-block\"]/div/ul/li/a[contains(@data-category, \"relevant-#{relevancy}\")]/span[1]"
    end

    def doc
      @doc ||= Nokogiri::HTML.parse(open(@url).read)
    end
  end
end
