require "rails_helper"

class Authentication < ActionController::Base
  include Authenticable
end

describe Authenticable do 
  let(:authentication) { Authentication.new}

  subject { authentication }

  describe "#current_user" do 
    before do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      allow(authentication).to receive(:request).and_return(request)   
    end

  it "returns user from authorization header" do 
    expect(authentication.current_user.auth_token).to eq @user.auth_token
  end
end

  describe "authenticate_with_token" do
  	before do 
      @user = FactoryGirl.create :user
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({"errors"=>"Not authenticated"}.to_json)
      allow(authentication).to receive(:response).and_return(response)
    end

    it "renders json response" do
      expect(json_response[:errors]).to eq "Not authenticated"
    end

    it { should respond_with 401 }
  end

  describe "#user_signed_in" do 
    before do 
      @user = FactoryGirl.create :user 
    end

    context "when there is a user in session" do
      before do
        allow(authentication).to receive(:current_user).and_return(@user)
      end

    it { should be_user_signed_in}
    end

    context "when there is no session" do 
      before do 
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it { should_not be_user_signed_in }
    end
  end
end