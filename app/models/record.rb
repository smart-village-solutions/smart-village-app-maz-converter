# frozen_string_literal: true

class Record < ApplicationRecord
  audited only: :updated_at

  has_one_attached :image
  has_many_attached :related_images


  def convert_maz_json_to_sva_json
    return if json_data.blank?

    news_data = parse_single_news_from_json(json_data)
    self.sva_json_data = { news: [news_data] }
  end

  private

    def parse_single_news_from_json(json_hash)
      result = {
        external_id: json_hash.dig("_id").to_s,
        title: json_hash.dig("title", "value"),
        publication_date: parse_date(json_hash, "publication_date"),
        published_at: parse_date(json_hash, "publish_date"),
        show_publish_date: json_hash.dig("show_publish_date", "value"),
        news_type: "news article",
        address: parse_address(json_hash),
        content_blocks: ContentBlockParser.perform(json_hash, self)
      }
      result.merge(parse_url(json_data))
    end

    def parse_address(json_hash)
      if json_hash.dig("geo_location", "value", "latitude").blank? || json_hash.dig("geo_location", "value", "longitude").blank?
        {
          city: json_hash.dig("location_name", "value")
        }
      else
        {
          city: json_hash.dig("location_name", "value"),
          geo_location: {
            latitude: json_hash.dig("geo_location", "value", "latitude").to_f,
            longitude: json_hash.dig("geo_location", "value", "longitude").to_f
          }
        }
      end
    end

    def parse_url(json_hash)
      # TODO: prüfen ob mit http wenn mit dann description absolute
      # otherwise relative
      # prüfen ob url mit http://www.maz-online anfängt und nur falls ja parsen.
      return {} if json_hash.dig("portal_urls").blank?
      return {} if json_hash.dig("portal_urls").first.blank?

      {
        source_url: {
          url: json_hash.dig("portal_urls").first["portal_url"],
          description: ""
        }
      }
    end

    def parse_date(json_hash, date_key)
      return Time.zone.now unless json_hash.dig(date_key, "value").present?

      json_hash.dig(date_key, "value", "date") || json_hash.dig("publish_date", "value")
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
