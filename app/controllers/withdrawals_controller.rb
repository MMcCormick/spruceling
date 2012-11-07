class WithdrawalsController < ApplicationController
  before_filter :authenticate_user!

  # GET /withdrawals
  # GET /withdrawals.json
  #def index
  #  authorize! :manage, :all
  #  @withdrawals = Withdrawal.all
  #
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render json: @withdrawals }
  #  end
  #end

  # GET /withdrawals/1
  # GET /withdrawals/1.json
  #def show
  #  @withdrawal = Withdrawal.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @withdrawal }
  #  end
  #end

  # GET /withdrawals/new
  # GET /withdrawals/new.json
  def new
    @user = current_user
    @withdrawal = Withdrawal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @withdrawal }
    end
  end

  # POST /withdrawals
  # POST /withdrawals.json
  def create
    @user = current_user
    @withdrawal = Withdrawal.generate(@user)

    respond_to do |format|
      if @withdrawal.valid? && @user.withdraw_from_account(@withdrawal.amount)
        @withdrawal.save
        @user.save
        format.html { render action: "new", notice: 'Withdrawal was successfully created.' }
        format.json { render json: @withdrawal, status: :created, location: @withdrawal }
      else
        format.html { render action: "new", notice: "Withdrawal could not be completed" }
        format.json { render json: @withdrawal.errors, status: :unprocessable_entity }
      end
    end
  end
end
