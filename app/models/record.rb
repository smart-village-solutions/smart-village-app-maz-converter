# frozen_string_literal: true

class Record < ApplicationRecord
  audited only: :updated_at
  before_save :convert_maz_json_to_sva_json
  after_save :send_sva_json_to_server

  private

  def convert_maz_json_to_sva_json
    news_data = parse_single_news_from_json(self.json_data)
    self.sva_json_data = { news_item: news_data }
  end

  def parse_single_news_from_json(json_hash)
    {
      external_id: json_hash.dig("_id"),
      title: json_hash.dig("title", "value"),
      author: "Tim Test",
      publication_date: json_hash.dig("publication_date", "value"),
      published_at: json_hash.dig("publish_date", "value"),
      show_publish_date: json_hash.dig("show_publish_date", "value"),
      news_type: json_hash.dig("show_publish_date", "value"),
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
      city: json_hash.dig("location_name", "value"),
      geo_location: {
        latitude: json_hash.dig("geo_location", "value", "latitude"),
        longitude: json_hash.dig("geo_location", "value", "longitude")
      }
    }
  end

  def parse_url(json_hash)
    # TODO: prüfen ob mit http wenn mit dann description absolute
    # otherwise relative
    # prüfen ob url mit http://www.maz-online anfängt und nur falls ja parsen.
    return nil if json_hash.dig("portal_urls")
    json_hash.dig("portal_urls").map do |url|
      {
        url: url["portal_url"],
        description: ""
      }
    end
  end

  def send_sva_json_to_server
    access_token = Authentication.new.access_token
    url = Rails.application.credentials.target_server[:url]

    begin
      result = ApiRequestService.new(url, nil, nil, self.sva_json_data, {Authorization: "Bearer #{access_token}"}).post_request
      self.update_columns(updated_at: Time.now, audit_comment: result.body)
    rescue => e
      self.update_columns(updated_at: Time.now, audit_comment: e)
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
