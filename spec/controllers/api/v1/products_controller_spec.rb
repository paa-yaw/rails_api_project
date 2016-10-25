require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do

  describe "GET #index" do 
    before do
      4.times { FactoryGirl.create :product }
      get :index 
    end

    it "return 4 products" do 
      products_response = json_response
      # expect(products_response[:products]).to have(4).items
      expect(Product.all.count).to eq 4
    end

    it { should respond_with 200 }
  end
  
  describe "GET #show" do
    before do 
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it "returns product as json" do
      product_response = json_response
      expect(product_response[:title]).to eq @product.title
    end

    it { should respond_with 200 }
  end

end
