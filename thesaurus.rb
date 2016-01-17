require 'nokogiri'
require 'open-uri'

class Thesaurus
  URL = 'http://thesaurus.com/browse/'

  RELEVANCY_MAP = {high: 3, middle: 2, low: 1}

  def initialize(word)
    @url = URI.encode("#{URL}#{word}")
  end

  def synonyms(relevancy:)
    raise "illegal relevancy. choose from #{RELEVANCY_MAP}" unless RELEVANCY_MAP.include?(relevancy.to_sym)

    doc.xpath("//#{relevancy_block_xpath_query(relevancy: RELEVANCY_MAP[relevancy.to_sym])}").map(&:text)
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
