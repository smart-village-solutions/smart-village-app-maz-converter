# frozen_string_literal: true

Rails.application.routes.draw do

  post "json", to: "api#create"
  post "send", to: "api#send_to_main_server"

  delete "/json/:id", to: "api#destroy", defaults: { format: "json" }

  match "oauth/confirm_access", to: "oauth#confirm_access", via: %i[get post]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
