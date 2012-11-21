require 'spec_helper'

describe BoxesController do
  let (:valid_attributes) {FactoryGirl.attributes_for(:box)}
  before (:each) do
    @box = FactoryGirl.create(:box)
    sign_in @box.user
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should render the index template" do
      get :index
      response.should render_template("index")
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

      describe "pagination" do
        it "should return the first element on the first page" do
          @box2 = FactoryGirl.create(:box, :gender => "m")
          get :index, {:gender => "m", :page => "1"}
          assigns(:boxes).should include @box2
        end

        it "should not return the first element on the first page" do
          @box2 = FactoryGirl.create(:box, :gender => "m")
          get :index, {:gender => "m", :page => "2"}
          assigns(:boxes).should_not include @box2
        end
      end
    end
  end

  describe "GET show" do
    it "assigns the requested box as @box" do
      get :show, {:id => @box.to_param}
      assigns(:box).should eq(@box)
    end
  end

  describe "GET new" do
    it "assigns a new box as @box" do
      get :new, {}
      assigns(:box).should be_a_new(Box)
    end

    it "should require you to be signed in" do
      sign_out @box.user
      get :new
      response.should redirect_to(new_user_session_path)
    end

    it "should redirect to edit_address if the user doesn't have an address" do
      @box.user.address = nil
      @box.user.save
      get :new
      response.should redirect_to(edit_user_address_path)
    end
  end

  describe "GET edit" do
    it "assigns the requested box as @box" do
      get :edit, {:id => @box.to_param}
      assigns(:box).should eq(@box)
    end

    it "should deny users without permissions" do
      sign_in FactoryGirl.create(:user)
      expect do
        put :edit, {:id => @box.to_param, :item_id => @item.to_param}
      end.to raise_error(CanCan::AccessDenied)
    end  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new box" do
        expect {
          post :create, {:box => valid_attributes}
        }.to change(Box, :count).by(1)
      end

      it "assigns a newly created box as @box" do
        post :create, {:box => valid_attributes}
        assigns(:box).should be_a(Box)
        assigns(:box).should be_persisted
      end

      it "redirects to the created box" do
        post :create, {:box => valid_attributes}
        response.should redirect_to(Box.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved box as @box" do
        # Trigger the behavior that occurs when invalid params are submitted
        Box.any_instance.stub(:save).and_return(false)
        post :create, {:box => {}}
        assigns(:box).should be_a_new(Box)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Box.any_instance.stub(:save).and_return(false)
        post :create, {:box => {}}
        response.should render_template("new")
      end
    end

    it "should require you to be signed in" do
      sign_out @box.user
      get :create
      response.should redirect_to(new_user_session_path)
    end

    it "should redirect to edit_address if the user doesn't have an address" do
      @box.user.address = nil
      @box.user.save
      get :new
      response.should redirect_to(edit_user_address_path)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested box" do
        # Assuming there are no other boxes in the database, this
        # specifies that the Box created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Box.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => @box.to_param, :box => {'these' => 'params'}}
      end

      it "assigns the requested box as @box" do
        put :update, {:id => @box.to_param, :box => valid_attributes}
        assigns(:box).should eq(@box)
      end

      it "redirects to the box" do
        put :update, {:id => @box.to_param, :box => valid_attributes}
        response.should redirect_to(@box)
      end
    end

    describe "with invalid params" do
      it "assigns the box as @box" do
        # Trigger the behavior that occurs when invalid params are submitted
        Box.any_instance.stub(:save).and_return(false)
        put :update, {:id => @box.to_param, :box => {}}
        assigns(:box).should eq(@box)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Box.any_instance.stub(:save).and_return(false)
        put :update, {:id => @box.to_param, :box => {}}
        response.should render_template("edit")
      end
    end

    it "should deny users without permissions" do
      sign_in FactoryGirl.create(:user)
      expect do
        put :update, {:id => @box.to_param, :item_id => @item.to_param}
      end.to raise_error(CanCan::AccessDenied)
    end
  end

  describe "PUT add_item" do
    before(:each) do
      @item = FactoryGirl.create(:item)
      sign_in @box.user
    end

    it "assigns the requested box as @box and item as @item" do
      put :add_item, {:id => @box.to_param, :item_id => @item.to_param}
      assigns(:item).should eq(@item)
      assigns(:box).should eq(@box)
    end

    describe "with valid params" do
      it "adds the requested item" do
        Box.any_instance.should_receive(:add_item).with(@item)
        put :add_item, {:id => @box.to_param, :item_id => @item.to_param}
      end

      it "redirects to the box" do
        Box.any_instance.stub(:add_item).and_return(true)
        put :add_item, {:id => @box.to_param, :item_id => @item.to_param}
        response.should redirect_to(@box)
      end
    end

    it "re-renders the 'edit' template if adding the item fails" do
      # Trigger the behavior that occurs when invalid params are submitted
      Box.any_instance.stub(:add_item).and_return(false)
      put :add_item, {:id => @box.to_param, :item_id => @item.to_param}
      response.should render_template("edit")
    end

    it "should deny users without permissions" do
      sign_in FactoryGirl.create(:user)
      expect do
        put :add_item, {:id => @box.to_param, :item_id => @item.to_param}
      end.to raise_error(CanCan::AccessDenied)
    end
  end

  describe "PUT remove_item" do
    before(:each) do
      @item = FactoryGirl.create(:item)
    end

    context "with valid params" do
      it "removes the requested item" do
        Box.any_instance.should_receive(:remove_item).with(@item)
        put :remove_item, {:id => @box.to_param, :item_id => @item.to_param}
      end

      it "assigns the requested box as @box" do
        put :remove_item, {:id => @box.to_param, :item_id => @item.to_param}
        assigns(:box).should eq(@box)
      end

      it "redirects to the box" do
        Box.any_instance.stub(:remove_item).and_return(true)
        put :remove_item, {:id => @box.to_param, :item_id => @item.to_param}
        response.should redirect_to(@box)
      end
    end

    it "should deny users without permissions" do
      sign_in FactoryGirl.create(:user)
      expect do
        put :remove_item, {:id => @box.to_param, :item_id => @item.to_param}
      end.to raise_error(CanCan::AccessDenied)
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested box" do
      expect {
        delete :destroy, {:id => @box.to_param}
      }.to change(Box, :count).by(-1)
    end

    it "redirects to the boxes list" do
      delete :destroy, {:id => @box.to_param}
      response.should redirect_to(boxes_url)
    end

    it "should deny other non-admin users" do
      sign_in FactoryGirl.create(:user)
      expect do
        put :destroy, {:id => @box.to_param, :item_id => @item.to_param}
      end.to raise_error(CanCan::AccessDenied)
    end
  end

end
