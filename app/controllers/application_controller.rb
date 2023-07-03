class ApplicationController < ActionController::Base
  # Thanks Daniel: https://medium.com/@daniel.gyi/integrating-active-storage-with-your-existing-devise-framework-rails-bf9fc65a43c1
  # if u have more time: https://www.youtube.com/watch?v=BYvzLYRIZK4
  before_action :configure_permitted_parameters_for_user, if: :devise_controller?

  # Basically, UserController :)
  def configure_permitted_parameters_for_user
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:avatar, :email, :name, :password, :password_confirmation, :current_password)
    end
  end
end
