class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_user

  def render_404
    return render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  # def current_user
  #   # return user matching id from session variable
  #   return User.find_by(id: session[:user_id]) if session[:user_id]
  # end

  def require_login
    if @login_user.nil?
      flash[:status] = :failure
      flash[:result_text] = "You must be logged in to do that"
      redirect_to root_path
    end
  end
  private

  def find_user
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
  end
end
