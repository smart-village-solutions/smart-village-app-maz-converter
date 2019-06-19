# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :restrict_access

  def create
    params.delete(:action)
    params.delete(:controller)
    maz_json = params.as_json

    @record = Record.new(json_data: maz_json)

    if @record.save
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
      whitelist = ["0.0.0.0", "127.0.0.1", "18.194.118.243"].freeze

      unless whitelist.include? request.remote_ip
        render json: {
          error_message: "Access denied"
        }, status: 401
      end
    end
end
