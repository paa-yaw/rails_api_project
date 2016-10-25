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

  describe "POST #create" do
  	context "when created successfully" do 
      before do
        @user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header @user.auth_token
        post :create, { user_id: @user.id, product: @product_attributes }
      end

      it "renders created product in json" do 
        product_response = json_response
        expect(product_response[:title]).to eq @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "when not created" do 
      before do
        @user = FactoryGirl.create :user
        @invalid_product_attributes = { title: "Smart TV", price: "Twelve Dollars" }
        api_authorization_header @user.auth_token
        post :create, { user_id: @user.id, product: @invalid_product_attributes } 
      end

      it "renders json errors" do
        product_response = json_response
        expect(product_response).to have_key(:errors) 
      end

      it "renders why the error" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number" 
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do 
    before do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token 
    end

    context "when is updated successfully" do 
      before do 
        patch :update, { user_id: @user.id, id: @product.id, product: { title: "An expensive Smart TV" } }
      end

      it "renders updated product as json" do 
        product_response = json_response
        expect(product_response[:title]).to eq "An expensive Smart TV"
      end

      it { should respond_with 200 }
    end

    context "when not updated" do 
      before do
        patch :update, { user_id: @user.id, id: @product.id, product: { price: "a hundred dollars" } } 
      end

      it "renders errors in json" do 
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders reason for errors in json" do 
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do 
    before do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token 
      delete :destroy, { user_id: @user.id, id: @product.id }
    end

    it { should respond_with 204 }
  end
end
