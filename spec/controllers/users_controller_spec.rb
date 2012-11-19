require 'spec_helper'

describe UsersController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'show'" do
    before(:each) do
      @box = FactoryGirl.create(:box)
      @box2 = FactoryGirl.create(:box, :user => @user)
    end

    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end

    it "should render the show template" do
      get :show, {:id => @user.id}
      response.should render_template("show")
    end

    it "assigns the user" do
      get :show, {:id => @user.id}
      assigns(:user).should eq(@user)
    end

    it "assigns all the user's boxes as @boxes" do
      get :show, {:id => @user.id}
      assigns(:boxes).to_a.should eq([@box2])
    end

    it "should include boxes which belong to the current user" do
      get :show, {:id => @user.id}
      assigns(:boxes).should include @box2
    end

    it "should not include boxes which do not belong to the current user" do
      get :show, {:id => @user.id}
      assigns(:boxes).should_not include @box
    end

    it "should not include inactive boxes" do
      @box3 = FactoryGirl.create(:box, :status => "sold", :user => @user)
      get :show, {:id => @user.id}
      assigns(:boxes).should_not include @box3
    end
  end

  describe "PUT update_stripe" do
    before(:each) do
      request.env["HTTP_REFERER"] = "foobar"
    end

    it "redirects back" do
      post :update_stripe, {:stripeToken => 'foo'}
      response.should redirect_to "foobar"
    end

    describe "with valid params" do
      it "updates the user" do
        User.any_instance.should_receive(:update_stripe).with('foo')
        post :update_stripe, {:stripeToken => 'foo'}
      end
    end
  end

  describe "update_address" do
    before(:each) do
      request.env["HTTP_REFERER"] = "foobar"
    end

    it "should call #update_address" do
      User.any_instance.should_receive(:update_address).with({"address1" => "1512 Spruce Street"})
      put :update_address, {:address1 => "1512 Spruce Street"}
    end

    it "should redirect back" do
      put :update_address, {:address1 => "1512 Spruce Street"}
      response.should redirect_to "foobar"
    end

    context "when update_address is successful" do
      before(:each) do
        User.any_instance.should_receive(:update_address).with({"address1" => "1512 Spruce Street"}).and_return(true)
      end

      it "should call save" do
        User.any_instance.should_receive(:save)
        put :update_address, {:address1 => "1512 Spruce Street"}
      end
    end

    context "when update_address is unsuccessful" do
      before(:each) do
        User.any_instance.should_receive(:update_address).and_return(false)
      end

      it "should not call save" do
        User.any_instance.should_receive(:save).never
        put :update_address, {:address => {:address1 => "1512 Spruce Street"}}
      end
    end
  end

  describe "GET 'edit_address'" do
    it "should be successful" do
      get :edit_address
      response.should be_success
    end
  end

  describe "GET 'edit_payment'" do
    it "should be successful" do
      get :edit_payment
      response.should be_success
    end
  end
end
