require 'spec_helper'

describe BoxesController do
  let (:valid_attributes) {FactoryGirl.attributes_for(:box)}
  before (:each) do
    @box = FactoryGirl.create(:box)
    sign_in @box.user
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
        response.should redirect_to(edit_box_path(Box.last))
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

  describe "POST rate" do
    context "when the current user bought the box" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @order = FactoryGirl.create(:order, :user => @user)
        @order.add_box(@box)
        @order.save
        sign_in @user
      end
      it "should set the rating and review" do
        post :rate, { :id => @box.to_param, :box => { :rating => "2", :review => "foobar" } }
        @box.reload.rating.should == 2
        @box.review.should == "foobar"
      end
      it "should redirect back to the box" do
        post :rate, { :id => @box.to_param, :box => { :rating => "2", :review => "foobar" } }
        response.should.redirect_to @box
      end
      it "should set a flash alert if there is no rating" do
        post :rate, { :id => @box.to_param }
        flash[:alert].should_not be_nil
      end
    end
    it "should deny other users who did not buy the box" do
      sign_in FactoryGirl.create(:user)
      expect do
        post :rate, { :id => @box.to_param, :box => { :rating => "2" } }
      end.to raise_error(CanCan::AccessDenied)
    end
  end
end
