class ItemsController < ApplicationController
  before_filter :authenticate_user!

  # GET /items
  # GET /items.json
  def index
    @items = current_user.items.active

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    authorize! :edit, @item
  end

  # POST /items
  # POST /items.json
  def create
    @item = current_user.items.new(params[:item])
    if params[:item][:brand]
      brand = Brand.find_or_create_by_name(params[:item][:brand])
      @item.brand = brand
    end
    if params[:item][:box_id]
      @box = Box.find(params[:item][:box_id])
      authorize! :edit, @box
      @item.box = @box
    end

    respond_to do |format|
      if @item.save
        html = render_to_string :partial => 'items/form_teaser', :locals => {:item => @item}
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :json => {:item => @item, :recommended_price => @box.recommended_price, :form_teaser => html}, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render :json => {:errors => @item.errors}, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    authorize! :edit, @item

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @box = @item.box
    authorize! :delete, @item
    @item.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render :json => {:status => :ok, :recommended_price => @box.recommended_price} }
    end
  end
end
