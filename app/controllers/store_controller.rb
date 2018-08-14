class StoreController < ApplicationController
  include Current_Cart
  skip_before_action :authorize
  before_action :set_cart

  def index
    @products = Product.order(:title)
  end
end
