# frozen_string_literal: true

class ApiController < ApplicationController
  # before_action :restrict_access

  def create
    params.delete(:action)
    params.delete(:controller)
    maz_json = params.as_json

    @record = Record.new(json_data: maz_json)

    if @record.save
      send_sva_json_to_server(@record)
      render json: {
        message: "News Article was successfully imported"
      }, status: 201
    else
      render json: {
        error_message: "Error. News Item couldn't be imported. Please contact the admin."
      }, status: 400
    end
  end

  def destroy
    access_token = Authentication.new.access_token
    url = Rails.application.credentials.target_server[:url]
    json = create_json_to_delete_news_item(params)
    result = ApiRequestService.new(url, nil, nil, json, Authorization: "Bearer #{access_token}").post_request
    render json: {
      message: "#{result} News Article was successfully deleted"
    }, status: 200
  end

  def send_to_main_server
    records = Record.where("created_at >= ?", 14.days.ago)
    if records.present?
      records.each do |record|
        send_sva_json_to_server(record)
      end
      render json: { message: "#{records.count} records were send to main server" }
    else
      render json: { message: "No records to send" }
    end
  end

  def re_import_records
    records = Record.where("created_at >= ?", 14.days.ago)
    results = {}
    records.each do |record|
      maz_json = record.json_data
      news_data = record.send(:parse_single_news_from_json, maz_json)
      record.sva_json_data = { news: [news_data] }
      if record.save
        results[record.id] = "Record with id '#{record.id}'was re-imported."
      else
        results[record.id] = record.errors.full_messages.to_s
      end
    end
    render json: results.to_json
  end

  private

    def restrict_access
      whitelist = Rails.application.credentials.whitelist[:ips]
      unless whitelist.include? request.remote_ip
        render json: {
          error_message: "Access denied"
        }, status: 401
      end
    end

    def send_sva_json_to_server(record)
      access_token = Authentication.new.access_token
      url = Rails.application.credentials.target_server[:url]

      begin
        result = ApiRequestService.new(url, nil, nil, record.sva_json_data, Authorization: "Bearer #{access_token}").post_request
        record.update(updated_at: Time.now, audit_comment: result.body)
      rescue StandardError => e
        record.update(updated_at: Time.now, audit_comment: e)
      end
    end

    def create_json_to_delete_news_item(params)
      { news: [{
        external_id: params[:id],
        action: params[:action]
      }] }
    end
end
