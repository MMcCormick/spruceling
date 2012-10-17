require 'spec_helper'

describe UsersController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end
    
  end

  describe "PUT update_stripe" do
    describe "with valid params" do
      it "updates the user" do
        User.any_instance.should_receive(:update_stripe).with('foo')
        post :update_stripe, {:stripeToken => 'foo'}
      end

      it "redirects to the cart" do
        post :update_stripe, {:stripeToken => 'foo'}
        response.should redirect_to(cart_path)
      end
    end
  end

  describe "update_information" do
    context "when an address is passed" do
      it "should call #update_address" do
        User.any_instance.should_receive(:update_address).with({"address1" => "1512 Spruce Street"})
        put :update_information, {:address => {:address1 => "1512 Spruce Street"}}
      end
    end

    context "when no address is passed" do
      it "should not call #update_address" do
        @user.should_receive(:update_address).never
        put :update_information
      end
    end

    it "should call save" do
      User.any_instance.should_receive(:save)
      put :update_information
    end

    it "should redirect to edit_information when unsuccessful" do
      User.any_instance.should_receive(:save).and_return(false)
      put :update_information
      response.should redirect_to(edit_user_information_path)
    end

    pending "should redirect to the user's profile when successful" do
      User.any_instance.should_receive(:save).and_return(true)
      put :update_information
      response.should redirect_to(user_path @user)
    end
  end
end
