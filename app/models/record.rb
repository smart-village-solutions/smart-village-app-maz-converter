class Record < ApplicationRecord
  audited only: :updated_at

  attr_accessor :current_user

  # def initialize(current_user: nil)
  #   @current_user = current_user
  #   super
  # end

  def load_json_data

  end

  def convert_to_json(hash_data)
    hash_data.to_json
  end

  def convert_json_to_hash
    news_data = []

    json_doc = JSON.parse(File.read("doc/Klimawandel.json"))

    news_data << parse_single_news_from_json(json_doc)
    byebug
    self.json_data = { news_items: news_data }
  end

  def parse_single_news_from_json(json_hash)
    {
      author: "Tim Test",
      full_version: "???",
      characters_to_be_shown: "???",
      publication_date: json_hash["publication_date"]["value"],
      published_at: json_hash["publish_date"]["value"],
      show_publish_date: json_hash["show_publish_date"]["value"],
      news_type: json_hash["show_publish_date"]["value"],
      data_provider: "",
      address: parse_address(json_hash),
      source_url: parse_url(json_hash),
      content_blocks: ContentBlockParser.perform(json_hash)
    }
  end

  def set_full_version
    ""
  end

  def parse_address(json_hash)
    {
     city: json_hash["location_name"]["value"],
     geo_location: {
       latitude: json_hash["geo_location"]["value"]["latitude"],
       longitude: json_hash["geo_location"]["value"]["longitude"]
     }
    }
  end

  def parse_url(json_hash)
    # todo prüfen ob mit http wenn mit dann description absolute
    # otherwise relative
    # prüfen ob url mit http://www.maz-online anfängt und nur falls ja parsen.
    json_hash["portal_urls"].map do |url|
      {
        url: url["portal_url"],
        description: ""
      }
    end
  end

end

# == Schema Information
#
# Table name: records
#
#  id          :bigint           not null, primary key
#  external_id :string
#  json_data   :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
