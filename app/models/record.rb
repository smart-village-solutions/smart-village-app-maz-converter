# frozen_string_literal: true

class Record < ApplicationRecord
  audited only: :updated_at
  before_save :convert_json_to_hash

  private
  def convert_json_to_hash
    news_data = []

    json_to_import = json_data
    json_to_import.each do |json_item|
      news_data << parse_single_news_from_json(json_item)
    end
    self.sva_json_data = { news_items: news_data }
  end

  def parse_single_news_from_json(json_hash)
    {
      external_id: json_hash["_id"],
      title: json_hash["title"],
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
    # TODO: prüfen ob mit http wenn mit dann description absolute
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
