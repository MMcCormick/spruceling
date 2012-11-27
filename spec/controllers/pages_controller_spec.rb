require 'spec_helper'

describe PagesController do
  before (:each) do
    @box = FactoryGirl.create(:box)
    @user = FactoryGirl.create(:user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :home
      response.should be_success
    end
  end

end
