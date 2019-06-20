# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :restrict_access

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
end
