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

end
