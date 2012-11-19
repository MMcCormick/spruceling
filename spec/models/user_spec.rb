# == Schema Information
#
# Table name: users
#
#  address                :hstore
#  authentication_token   :string(255)
#  balance                :decimal(8, 2)    default(0.0), not null
#  birthday               :date
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  created_at             :datetime         not null
#  credits                :integer
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  fb_secret              :string(255)
#  fb_token               :string(255)
#  fb_uid                 :string(255)
#  fb_use_image           :boolean
#  gender                 :string(255)
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  name                   :string(255)
#  origin                 :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  slug                   :string(255)
#  stripe_customer_id     :string(255)
#  unconfirmed_email      :string(255)
#  updated_at             :datetime         not null
#  username               :string(255)
#

require 'spec_helper'

describe User do

  it "should create a new instance given a valid attribute" do
    FactoryGirl.create(:user)
  end
  it "should require balance" do
    FactoryGirl.build(:user, :balance => nil).should be_invalid
  end

  describe "emails" do

    before(:each) do
      @user = FactoryGirl.build(:user)
    end

    it "should require an email address" do
      no_email_user = FactoryGirl.build(:user, :email => "")
      no_email_user.should_not be_valid
    end

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = FactoryGirl.build(:user, :email => address)
        valid_email_user.should be_valid
      end
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = FactoryGirl.build(:user, :email => address)
        invalid_email_user.should_not be_valid
      end
    end

    it "should reject duplicate email addresses" do
      FactoryGirl.create(:user, :email => "email@example.com")
      user_with_duplicate_email = FactoryGirl.build(:user, :email => "email@example.com")
      user_with_duplicate_email.should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      upcased_email = "foobar@example.com".upcase
      FactoryGirl.create(:user, :email => upcased_email)
      user_with_duplicate_email = FactoryGirl.build(:user, :email => "foobar@example.com")
      user_with_duplicate_email.should_not be_valid
    end

  end
  
  describe "passwords" do

    before(:each) do
      @user = FactoryGirl.build(:user)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end

    it "should require a password" do
      FactoryGirl.build(:user, :password => "", :password_confirmation => "").should_not be_valid
    end

    it "should require a matching password confirmation" do
      FactoryGirl.build(:user, :password_confirmation => "invalid").should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      FactoryGirl.build(:user, :password => short, :password_confirmation => short).should_not be_valid
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

  describe "stripe payments" do

    let (:stripe_customer) do
      stub_model Stripe::Customer, :id => 'foo', :card => '123'
    end

    before(:each) do
      @user = FactoryGirl.build(:user)
    end

    it "should have a stripe attribute" do
      @user.should respond_to(:stripe_customer_id)
    end

    describe "#stripe" do
      it "should return stripe customer if stripe_customer_id" do
        @user.stripe_customer_id = 'foo'
        Stripe::Customer.should_receive(:retrieve).and_return(stripe_customer)
        @user.stripe.should eq(stripe_customer)
      end
      it "should return nil if not stripe_customer_id" do
        @user.stripe_customer_id = nil
        @user.stripe.should eq(nil)
      end
    end

    describe "#update_stripe" do
      it "should update stripe_customer_id if nil" do
        @user.stripe_customer_id = nil
        Stripe::Customer.should_receive(:create).and_return(stripe_customer)
        @user.update_stripe('foo')
        @user.stripe_customer_id.should eq(stripe_customer.id)
      end
      it "should call save on the stripe customer object if stripe_customer_id exists" do
        @user.should_receive(:stripe).and_return(stripe_customer)
        Stripe::Customer.any_instance.should_receive(:save)
        @user.update_stripe('foo')
      end
      it "should update stripe customer object if stripe_customer_id exists" do
        @user.stripe_customer_id = 1
        @user.should_receive(:stripe).and_return(stripe_customer)
        @user.update_stripe('foo')
        stripe_customer.card.should eq('foo')
      end
    end

  end

  describe 'cart' do

    it 'should not be nil' do
      user = FactoryGirl.create(:user)
      user.cart.should_not be_nil
    end

    it 'should be persisted' do
      user = FactoryGirl.create(:user)
      user.cart.should be_persisted
    end

  end

  describe "update_address" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    let(:address) {{
      "full_name" => "Matt McCormick",
      "address1" => "1512 Spruce Street",
      "address2" => "Apt 507",
      "city" => "Philadelphia",
      "state" => "PA",
      "zip_code" => "19102"
    }}

    context "with a valid Stamps response" do
      let(:stamps_response) {{
        :address => {
          "full_name" => "Matt McCormick",
          "address1" => "1512 Spruce Street",
        }
      }}
      before(:each) do
        Stamps.should_receive(:clean_address).and_return(stamps_response)
      end

      it "should call Stamps.clean_address" do
        @user.update_address(address)
      end

      it "should set the address to the standardized address" do
        @user.update_address(address)
        @user.address.should == stamps_response[:address]
      end

      it "should return the standardized address" do
        @user.update_address(address).should == stamps_response[:address]
      end
    end

    context "with an invalid Stamps response" do
      let(:stamps_response) {{
        :errors => ["Foo error"],
        :valid? => false
      }}
      before(:each) do
        Stamps.should_receive(:clean_address).and_return(stamps_response)
      end

      it "should return false" do
        @user.update_address(address).should == false
      end

      it "should not change the stored address" do
        @user.address = "foo"
        expect {
          @user.update_address(address)
        }.to_not change{@user.address}
      end
    end
  end

  describe "#credit_account" do
    before(:each) do
      @user = FactoryGirl.create(:user, :balance => 50.00)
    end

    it "should add the amount to the user's balance" do
      @user.credit_account(24.50)
      @user.balance.should == 74.50
    end

    it "should return true for any positive number" do
      @user.credit_account(15.75).should == true
    end

    it "should return false for anything <= 0" do
      @user.credit_account(0).should == false
      @user.credit_account(-1).should == false
      @user.balance.should == 50.00
    end
  end

  describe "#withdraw_from_account" do
    before(:each) do
      @user = FactoryGirl.create(:user, :balance => 50.00)
    end

    it "should subtract the amount from the user's balance" do
      @user.withdraw_from_account(24.50)
      @user.balance.should == 25.50
    end

    it "should return false for anything <= 0" do
      @user.credit_account(0).should == false
      @user.balance.should == 50.00
      @user.credit_account(-1).should == false
      @user.balance.should == 50.00
    end

    it "should return true when amount is less than balance" do
      @user.withdraw_from_account(15.75).should == true
    end

    it "should return false when amount is greater than balance" do
      @user.withdraw_from_account(100).should == false
      @user.balance.should == 50.00
    end
  end
end