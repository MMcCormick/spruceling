require 'spec_helper'

describe ItemsController do
  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @item = FactoryGirl.create(:item, :user => @user)
  end

  describe "GET index" do
    it "assigns current user's items as @items" do
      get :index
      assigns(:items).should eq([@item])
    end

    it "should not assign items which do not belong to the current user" do
      @item2 = FactoryGirl.create(:item, :user => FactoryGirl.create(:user))
      get :index
      assigns(:items).should_not include @item2
    end

    it "should not include inactive items" do
      @item2 = FactoryGirl.create(:item, :user => @user, :status => "sold")
      get :index
      assigns(:items).should_not include @item2
    end

    it "should require you to be signed in" do
      sign_out @user
      get :create
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET show" do
    it "assigns the requested item as @item" do
      get :show, {:id => @item.to_param}
      assigns(:item).should eq(@item)
    end
  end

  describe "GET new" do
    it "assigns a new item as @item" do
      get :new, {}
      assigns(:item).should be_a_new(Item)
    end

    it "should require you to be signed in" do
      sign_out @user
      get :create
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET edit" do
    it "assigns the requested item as @item" do
      get :edit, {:id => @item.to_param}
      assigns(:item).should eq(@item)
    end

    it "should deny users without permissions" do
      sign_in FactoryGirl.create(:user)
      expect do
        put :edit, {:id => @item.to_param}
      end.to raise_error(CanCan::AccessDenied)
    end
  end

  describe "POST create" do
    before(:each) do
      request.env["HTTP_REFERER"] = "foobar"
    end

    it "redirects back" do
      post :create, {:item => FactoryGirl.build(:item).attributes}
      response.should redirect_to("foobar")
    end

    describe "with valid params" do
      it "creates a new item" do
        expect {
          post :create, {:item => FactoryGirl.build(:item).attributes}
        }.to change(Item, :count).by(1)
      end

      it "assigns a newly created item as @item" do
        post :create, {:item => FactoryGirl.build(:item).attributes}
        assigns(:item).should be_a(Item)
        assigns(:item).should be_persisted
      end

      it "should assign the item to the current user" do
        post :create, {:item => FactoryGirl.build(:item).attributes}
        assigns(:item).user.should eq(@user)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved item as @item" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        post :create, {:item => {}}
        assigns(:item).should be_a_new(Item)
      end
    end

    it "should require you to be signed in" do
      sign_out @user
      post :create
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested item" do
        # Assuming there are no other items in the database, this
        # specifies that the Item created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Item.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => @item.to_param, :item => {'these' => 'params'}}
      end

      it "assigns the requested item as @item" do
        put :update, {:id => @item.to_param, :item => FactoryGirl.build(:item).attributes}
        assigns(:item).should eq(@item)
      end

      it "redirects to the item" do
        put :update, {:id => @item.to_param, :item => FactoryGirl.build(:item).attributes}
        response.should redirect_to(@item)
      end
    end

    describe "with invalid params" do
      it "assigns the item as @item" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        put :update, {:id => @item.to_param, :item => {}}
        assigns(:item).should eq(@item)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        put :update, {:id => @item.to_param, :item => {}}
        response.should render_template("edit")
      end
    end

    it "should deny users without permissions" do
      sign_in FactoryGirl.create(:user)
      expect do
        put :update, {:id => @item.to_param}
      end.to raise_error(CanCan::AccessDenied)
    end    end

  describe "DELETE destroy" do
    before(:each) do
      request.env["HTTP_REFERER"] = "foobar"
    end

    it "destroys the requested item" do
      expect {
        delete :destroy, {:id => @item.to_param}
      }.to change(Item, :count).by(-1)
    end

    it "redirects to the items list" do
      delete :destroy, {:id => @item.to_param}
      response.should redirect_to("foobar")
    end

    it "should deny users without permissions" do
      sign_in FactoryGirl.create(:user)
      expect do
        put :destroy, {:id => @item.to_param}
      end.to raise_error(CanCan::AccessDenied)
    end
  end

end
