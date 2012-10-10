require 'spec_helper'

describe BoxesController do
  before (:each) do
    @box = FactoryGirl.create(:box)
  end

  describe "GET index" do
    it "should render the index template" do
      get :index
      response.should render_template("index")
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

  describe "GET my_boxes" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @box2 = FactoryGirl.create(:box, :user => @user)
      sign_in @user
    end

    it "should render the my_boxes template" do
      get :my_boxes
      response.should render_template("my_boxes")
    end

    it "assigns all the user's boxes as @boxes" do
      get :my_boxes
      assigns(:boxes).to_a.should eq([@box2])
    end

    it "should include boxes which belong to the current user" do
      get :my_boxes
      assigns(:boxes).should include @box2
    end

    it "should not include boxes which do not belong to the current user" do
      get :my_boxes
      assigns(:boxes).should_not include @box
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
  end

  describe "GET edit" do
    it "assigns the requested box as @box" do
      get :edit, {:id => @box.to_param}
      assigns(:box).should eq(@box)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new box" do
        expect {
          post :create, {:box => FactoryGirl.build(:box).attributes}
        }.to change(Box, :count).by(1)
      end

      it "assigns a newly created box as @box" do
        post :create, {:box => FactoryGirl.build(:box).attributes}
        assigns(:box).should be_a(Box)
        assigns(:box).should be_persisted
      end

      it "redirects to the created box" do
        post :create, {:box => FactoryGirl.build(:box).attributes}
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
        put :update, {:id => @box.to_param, :box => FactoryGirl.build(:box).attributes}
        assigns(:box).should eq(@box)
      end

      it "redirects to the box" do
        put :update, {:id => @box.to_param, :box => FactoryGirl.build(:box).attributes}
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
  end

  describe "PUT add_item" do
    before(:each) do
      @item = FactoryGirl.create(:item)
    end

    describe "with valid params" do
      it "adds the requested item" do
        Box.any_instance.should_receive(:add_item).with(@item)
        put :add_item, {:id => @box.to_param, :item_id => @item.to_param}
      end

      it "assigns the requested box as @box" do
        put :add_item, {:id => @box.to_param, :item_id => @item.to_param}
        assigns(:box).should eq(@box)
      end

      it "redirects to the box" do
        Box.any_instance.stub(:add_item).and_return(true)
        put :add_item, {:id => @box.to_param, :item_id => @item.to_param}
        response.should redirect_to(@box)
      end
    end

    describe "with invalid params" do
      it "assigns the box as @box" do
        # Trigger the behavior that occurs when invalid params are submitted
        Box.any_instance.stub(:add_item).and_return(false)
        put :add_item, {:id => @box.to_param, :item_id => @item.to_param}
        assigns(:box).should eq(@box)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Box.any_instance.stub(:add_item).and_return(false)
        put :add_item, {:id => @box.to_param, :item_id => @item.to_param}
        response.should render_template("edit")
      end
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
  end

end
