require 'spec_helper'

describe User do

  it "should create a new instance given a valid attribute" do
    FactoryGirl.create(:user)
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
      user = FactoryGirl.build(:user)
      user.cart.should_not be_nil
    end

    it 'should be persisted' do
      user = FactoryGirl.create(:user)
      user.cart.should be_persisted
    end

  end

end