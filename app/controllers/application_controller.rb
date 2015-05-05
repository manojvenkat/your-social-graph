class ApplicationController < ActionController::Base
	include ActionView::Helpers::OutputSafetyHelper
  protect_from_forgery

  def hello
    render text: "hello, world!"
	end

private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

end