class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
    if User.count.zero?
      user_name = params[:name]
      password = params[:password]
      user = User.create(name: user_name, password: password)
      if user.try(:authenticate, password)
        session[:user_id] = user.id
        redirect_to admin_url
      end
    else
      user ||= User.find_by(name: params[:name])
      if user.try(:authenticate, params[:password])
        session[:user_id] = user.id
        redirect_to admin_url
      else
        redirect_to login_url, alert: "Invalid username/password combination"
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: "Logged out"
  end
end
