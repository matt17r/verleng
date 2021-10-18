class StaticController < ApplicationController
  rescue_from ActionView::MissingTemplate do |exception|
    raise ActionController::RoutingError, "No such page: #{params[:page]}"
  end

  def show
    render params[:page]
  end
end
