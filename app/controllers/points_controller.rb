class PointsController < ApplicationController
  before_action :set_point, only: [:show, :edit, :update, :destroy]
  
  respond_to :html

  def index
    @points = Point.all
    @json = @points.to_gmaps4rails do |point, marker|
      @point = point
      marker.infowindow render_to_string('points/show', :layout => false)    
      marker.json({ :id => @point.id })
    end
  end

  # GET /points/1
  # GET /points/1.json
  def show
    respond_with(@point, :layout =>  !request.xhr?)
  end

  # GET /points/new
  def new
    @point = Point.new(params[:point].present? ? point_params : nil)
    respond_with(@point, :layout => !request.xhr?)
  end

  # GET /points/1/edit
  def edit
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # POST /points
  # POST /points.json
  def create
    @point = Point.new(point_params)
    respond_to do |format|
      if @point.save
        format.html { redirect_to @point, notice: 'Playground was successfully created.' }
        format.js { }
      else
        format.html { render action: 'new' }
        format.js {render layout: false}     
      end
    end
  end

  # PATCH/PUT /points/1
  # PATCH/PUT /points/1.json
  def update
    respond_to do |format|
      if @point.update(point_params)
        format.html do
          puts "HTMLHTMLHTMLHTMLHTMLHTML"
          flash[:notice] = t('fishing_memories.model_updated', model: Point.model_name.human)
          redirect_to @point
        end
        format.js do
          puts "JSJSJSJSJSJSJSJSJSJSJ"
        end 
      else
        format.html { render action: 'edit' }
        format.js {}  
      end
    end
  end

  # DELETE /points/1
  # DELETE /points/1.json
  def destroy
    @point.destroy
    respond_to do |format|
      format.html { redirect_to points_url }
      format.js {}  
    end
  end


private
  # Use callbacks to share common setup or constraints between actions.
  def set_point
    @point = Point.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def point_params
    params.require(:point).permit(:name, :description, :map_id, :latitude, :longitude)
  end
  
end
