class UsersController < ApplicationController

  before_action :require_login, except: :create

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    if auth_hash
      user = User.find_by(uid: auth_hash["uid"], provider: "github" )
      if user
        flash[:status] = :success
        flash[:result_text] = "Logged in as returning user #{user.username}"
      else
        user = User.build_from_github(auth_hash)
        if user.save
          flash[:status] = :success
          flash[:result_text] = "Logged in as new user #{user.username}"
        else # save unsuccessful
          flash[:status] = :failure
          flash[:result_text] = "Could not create new user account. #{user.errors.full_messages.join(", ")}"
          return redirect_to root_path
        end
      end
    else # handles case when auth_hash is nil?
      flash[:status] = :failure
      flash[:result_text] = "Could not log in, #{params[:provider]} is not a valid provider"
      return redirect_to root_path
    end
    session[:user_id] = user.id
    return redirect_to root_path
  end

  def logout
    if session[:user_id]
      session[:user_id] = nil
      flash[:status] = :success
      flash[:result_text] = "Successfully logged out"
    else
      flash[:status] = :failure
      flash[:result_text] = "You were not logged in!"
    end
    return redirect_to root_path
  end
end
