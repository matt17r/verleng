Rails.application.routes.draw do
  root to: "static#show", page: "home"

  get "/page/:page" => "static#show"
end
