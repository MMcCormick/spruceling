require 'spec_helper'

describe WithdrawalsController do

  before (:each) do
    @user = FactoryGirl.create(:user, :balance => 40.00)
    sign_in @user
  end

  describe "GET new" do
    it "assigns a new withdrawal belonging to the current user as @withdrawal" do
      get :new
      assigns(:withdrawal).should be_a_new Withdrawal
      assigns(:withdrawal).user.should eq @user
    end
  end

  describe "POST create" do
    let(:withdrawal) { FactoryGirl.build(:withdrawal, :amount => @user.balance) }

    it "assigns a new withdrawal belonging to the current user as @withdrawal" do
      post :create
      assigns(:withdrawal).should be_a Withdrawal
      assigns(:withdrawal).user.should eq @user
    end

    describe "when the returned withdrawal is valid" do
      before(:each) do
        Withdrawal.should_receive(:generate).with(@user).and_return(withdrawal)
        withdrawal.should_receive(:valid?).and_return(true)
        @user.should_receive(:withdraw_from_account).and_return(true)
      end

      it "creates a new withdrawal" do
        expect {
          post :create
        }.to change(Withdrawal, :count).by(1)
      end

      it "assigns a newly created withdrawal as @withdrawal" do
        post :create
        assigns(:withdrawal).should be_a(Withdrawal)
        assigns(:withdrawal).should be_persisted
      end

      it "render the 'new' template" do
        post :create
        response.should render_template "new"
      end
    end

    describe "when the returned withdrawal is not valid" do
      before(:each) do
        Withdrawal.should_receive(:generate).with(@user).and_return(withdrawal)
        withdrawal.should_receive(:valid?).and_return(false)
      end

      it "should not call withdraw_from_account" do
        @user.should_receive(:withdraw_from_account).never
        post :create
      end

      it "should not save the withdrawal or user" do
        @user.should_receive(:save).never
        withdrawal.should_receive(:save).never
        post :create
      end

      it "assigns a newly created but unsaved withdrawal as @withdrawal" do
        # Trigger the behavior that occurs when invalid params are submitted
        post :create
        assigns(:withdrawal).should_not be_persisted
      end

      it "render the 'new' template" do
        post :create
        response.should render_template "new"
      end
    end

    it "should require you to be signed in" do
      sign_out @user
      get :create
      response.should redirect_to(new_user_session_path)
    end
  end
end
