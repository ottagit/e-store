class StoreController < ApplicationController
  include Current_Cart
  before_action :set_cart

  def index
    @products = Product.order(:title)
  end
end
