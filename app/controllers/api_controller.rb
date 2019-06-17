class ApiController < ApplicationController
  def create
    Record.create(json_data: params[data])
  end
end
