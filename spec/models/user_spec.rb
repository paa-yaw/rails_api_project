require 'rails_helper'


describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }

  it { should be_valid }

  it { should validate_presence_of(:email) }
  # it { should validate_uniqueness_of(:email) }
  it { should validate_confirmation_of(:password) }
  it { should allow_value("example@domain.com").for(:email) }
  it { should validate_uniqueness_of(:auth_token) }
  
  it { should have_many(:products) }

  describe "#generate_authentication_token!" do 
    it "generates a unique token" do 
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eq "auniquetoken123"
    end
  

    it "#generates another token if token generated already exists" do 
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eq existing_user.auth_token
    end

    describe "#product association" do 
      before do 
        @user.save
        3.times { FactoryGirl.create :product, user: @user }
      end

      it "destroy associated product on self destruct" do 
        products = @user.products

        @user.destroy

        products.each do |product|
          expect(Product.find(procuct)).to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
