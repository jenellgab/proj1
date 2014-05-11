require 'sinatra'
require './boot.rb'
require './money_calculator.rb'

# ROUTES FOR ADMIN SECTION

get '/admin' do
  @products = Item.all
  erb :admin_index
end

get '/new_product' do
  @product = Item.new
  erb :product_form
end

post '/create_product' do
	@item = Item.new
	@item.name = params[:name]
	@item.price = params[:price]
	@item.quantity = params[:quantity]
	@item.sold = 0
	@item.save
 	redirect to '/admin'
end

get '/edit_product/:id' do
  @product = Item.find(params[:id])
  erb :product_form
end

post '/update_product/:id' do
  @product = Item.find(params[:id])
  @product.update_attributes!(
    name: params[:name],
    price: params[:price],
    quantity: params[:quantity],
  )
  redirect to '/admin'
end

get '/delete_product/:id' do
  @product = Item.find(params[:id])
  @product.destroy!
  redirect to '/admin'
end
# ROUTES FOR ADMIN SECTION


get '/' do
	temp = []
	10.times do
		ran = rand(1..10)
		@item = Item.find(ran)
		temp << @item
	end 
		@array = temp
	erb :index
end

get '/about' do 
	erb :about
end 

get'/products' do
	@products = Item.all
  	erb :products
end

get '/buy/:id' do
	@product = Item.find(params[:id])
	erb :consumers_form
end
post '/buy/:id' do
	@product = Item.find(params[:id])
	num = params[:quantity].to_f + @product.sold.to_f
	quan = @product.quantity.to_f - params[:quantity].to_f
	@product.update_attributes!(
    sold: num,
	quantity: quan
  )
	@money = MoneyCalculator.new params[:ones], params[:fives],params[:tens], params[:twenty], params[:fifty], params[:hundred], params[:fhundred], params[:thousand], params[:quantity], @product.price

	erb :confirmation
end
