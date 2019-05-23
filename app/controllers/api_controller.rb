class ApiController < ApplicationController
  def create
    Record.create(json_data: "")
  end
end
