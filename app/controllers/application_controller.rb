class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  protect_from_forgery with: :exception


  def render_404
    # this will actually render a 404 page in production
    # raise ActionController::RoutingError.new('Not Found')
    render :index, status: :not_found
  end
end
