require 'spec_helper'

describe HomeController do
  before (:each) do
    @box = FactoryGirl.create(:box)
    @user = FactoryGirl.create(:user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    context "logged in" do
      before (:each) do
        sign_in @user
      end

      it "should render the home template" do
        get :index
        response.should render_template("home")
      end

      it "should not include inactive boxes" do
        @box2 = FactoryGirl.create(:box, :status => "sold")
        get :index
        assigns(:boxes).should_not include @box2
      end

      describe "without parameters" do
        it "assigns all boxes as @boxes" do
          get :index
          assigns(:boxes).to_a.should eq([@box])
        end
      end

      describe "with parameters" do
        it "should include boxes which match params" do
          @box2 = FactoryGirl.create(:box, :gender => "m")
          get :index, {:gender => "m"}
          assigns(:boxes).should include @box2
        end

        it "should not include boxes which do not match params" do
          @box2 = FactoryGirl.create(:box, :gender => "f")
          get :index, {:gender => "m"}
          assigns(:boxes).should_not include @box2
        end
      end
    end

    context "logged out" do
      it "should render the splash template" do
        get :index
        response.should render_template("splash")
      end
    end

  end

end
