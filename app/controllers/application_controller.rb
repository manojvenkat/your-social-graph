class ApplicationController < ActionController::Base
  protect_from_forgery

  def hello
    render text: "hello, world!"
	end

end
