class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    redirect_to projects_path if signed_in?
  end
end
