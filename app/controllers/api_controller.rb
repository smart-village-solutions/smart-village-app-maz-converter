# frozen_string_literal: true

class ApiController < ApplicationController
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
end
