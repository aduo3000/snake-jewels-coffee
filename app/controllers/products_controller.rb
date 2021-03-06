class ProductsController < ApplicationController
  http_basic_authenticate_with name: "aduo3000", password: "ZMxnCb$0", except: [:index, :show, :search]
  
  def new 
    @product = Product.new   
  end
  
  def create
    @product = Product.new(product_params)
 
    if @product.save
      redirect_to @product
    else
      render 'new'
    end    
  end
  
  def show
    @product = Product.find(params[:id])
    @unit = "oz" if @product.category == "Coffee"
    @unit = "feet" if @product.category == "Snakes"
    @unit = "carat" if @product.category == "Jewels"
   
    @sales_tax = 7.50
    @tax_price = (@product.price * (@sales_tax / 100)).round(2)
    @total = (@product.price + (@product.price * (@sales_tax / 100))).round(2)
  end
  
  def index        
   @q = Product.search(params[:q])
   @products = @q.result(distinct: true).paginate(:page => params[:page], :per_page => 10)
  end 
  
  def search
    index
    render :index
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
 
    if @product.update(product_params)
      redirect_to @product
    else
      render 'edit'
    end
end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
 
    redirect_to products_path
  end

  def server
  
  end  
private
  def product_params
    params.require(:product).permit(:title, :size, :category, :description, :price, :picture)
  end
  
end

