require 'spec_helper'

describe BoxesController do
  before (:each) do
    @box = FactoryGirl.create(:box)
  end

  describe "GET index" do
    it "assigns all boxs as @boxs" do
      get :index, {}
      assigns(:boxs).should eq([@box])
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

  describe "DELETE destroy" do
    it "destroys the requested box" do
      expect {
        delete :destroy, {:id => @box.to_param}
      }.to change(Box, :count).by(-1)
    end

    it "redirects to the boxs list" do
      delete :destroy, {:id => @box.to_param}
      response.should redirect_to(boxs_url)
    end
  end

end
