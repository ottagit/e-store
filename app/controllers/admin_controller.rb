class AdminController < ApplicationController
  def index
    @user = User.find_by(id: session[:user_id])
    @total_orders = Order.count
  end
end
