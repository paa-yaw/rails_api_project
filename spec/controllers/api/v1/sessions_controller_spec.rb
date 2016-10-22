require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  
  describe "POST #create" do 
    before(:each) do 
      @user = FactoryGirl.create :user
    end

    context "when the credentials are correct" do 
      before(:each) do
        credentials = { email: @user.email, password: "12345678" }
        post :create, { session: credentials }
      end

      it "returns user record corresponding to user's credentials" do
        @user.reload
        expect(json_response[:auth_token]).to eq @user.auth_token	
      end

      it { should respond_with 200 }
    end

    context "when credentials are incorrect" do
      before(:each) do
        credentials = { email:@user.email, password: "invalidpassword" }
        post :create, { session: credentials } 
      end 

      it "returns json with errors" do 
        expect(json_response[:errors]).to eq "Invalid email or password"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do 
  	before(:each) do 
  	  @user = FactoryGirl.create :user
  	  sign_in @user
  	  delete :destroy, id: @user.auth_token
  	end

  	it { should respond_with 204 }
  end
end
