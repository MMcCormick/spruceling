class BoxesController < ApplicationController
  before_filter :authenticate_user!, :only => [:my_boxes, :new, :create]

  # GET /index
  # GET /index.json
  def index
    @boxes = current_user.boxes.active

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boxes }
    end
  end

  # GET /boxes/1
  # GET /boxes/1.json
  def show
    @box = Box.find(params[:id])

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
      format.html # new.html.erb
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
    @box.items.each do |item|
      item.user = current_user
    end

    respond_to do |format|
      if @box.save
        format.html { redirect_to @box, notice: 'Box was successfully created.' }
        format.json { render json: @box, status: :created, location: @box }
      else
        foo = 'bar'
        format.html { render action: "new" }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /boxes/1
  # PUT /boxes/1.json
  def update
    @box = Box.find(params[:id])
    authorize! :edit, @box

    respond_to do |format|
      if @box.update_attributes(params[:box])
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
      format.json { head :no_content }
    end
  end
end
