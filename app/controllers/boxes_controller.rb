class BoxesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]

  # GET /index
  # GET /index.json
  def index
    @boxes = Box.by_filter(params.slice(:gender, :size)).active.page(params[:page]).per(8)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boxes }
    end
  end

  # GET /boxes/1
  # GET /boxes/1.json
  def show
    @box = Box.find(params[:id])
    @user = @box.user

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @box }
    end
  end

  # GET /boxes/new
  # GET /boxes/new.json
  def new
    @box = Box.new
    @box.items.build

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @box }
    end
  end

  # GET /boxes/1/edit
  def edit
    @box = Box.find(params[:id])
    authorize! :edit, @box
  end

  # POST /boxes
  # POST /boxes.json
  def create
    @box = current_user.boxes.build(params[:box])
    @box.status = 'draft'

    respond_to do |format|
      if current_user.address.blank?
        flash[:notice] = "Please provide your address before posting a box"
        format.html { redirect_to edit_user_address_path }
        format.json { render :json => {:edit_url => edit_user_address_path} }
      elsif @box.save
        format.html { redirect_to @box, notice: 'Box was successfully created.' }
        format.json { render :json => {:box => @box, :url => box_path(@box), :edit_url => edit_box_path(@box)}, status: :created, location: @box }
      else
        format.html { render action: "new" }
        format.json { render :json => {:errors => @box.errors}, status: :unprocessable_entity }
      end
    end
  end

  # PUT /boxes/1
  # PUT /boxes/1.json
  def update
    @box = Box.find(params[:id])
    authorize! :edit, @box

    respond_to do |format|
      @box.update_attributes(params[:box])
      @box.status = 'active'
      if @box.save
        format.html { redirect_to @box, notice: 'Box was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_item
    @box = Box.find(params[:id])
    @item = Item.find(params[:item_id])
    authorize! :edit, @box

    respond_to do |format|
      if @box.add_item(@item)
        @box.save
        @item.save
        format.html { redirect_to @box, notice: 'Box was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_item
    @box = Box.find(params[:id])
    @item = Item.find(params[:item_id])
    authorize! :edit, @box

    @box.remove_item(@item)

    respond_to do |format|
      if @box.save && @item.save
        format.html { redirect_to @box, notice: 'Box was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boxes/1
  # DELETE /boxes/1.json
  def destroy
    @box = Box.find(params[:id])
    authorize! :edit, @box

    @box.destroy

    respond_to do |format|
      format.html { redirect_to boxes_url }
      format.js
    end
  end

  # PUT /boxes/rate
  # PUT /boxes/rate
  def rate
    @box = Box.find(params[:id])
    raise CanCan::AccessDenied unless @box.ordered_by?(current_user)
    @box.update_attributes(params[:box])

    flash[:alert] = "You must provide a rating between 1 and 5" if params[:box][:rating].blank?
    respond_to do |format|
      if @box.save
        format.html { redirect_to @box }
        format.json { render json: @box }
      else
        format.html { render action: "edit" }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end
end
