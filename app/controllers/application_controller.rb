class ApplicationController < ActionController::Base

  def render_404
    # this will actually render a 404 page in production
    raise ActionController::RoutingError.new('Not Found')
  end
end
