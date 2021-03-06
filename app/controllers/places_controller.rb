class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token


  # GET /places
  # GET /places.json
  def index
    @places = Place.all
  end

  # GET /places/1
  # GET /places/1.json
  def show
  end

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit
  end

  def changestatus
     @search = []
     @place =  Place.new
     @location = ""
     @ship = ""
     if params[:search] != nil
       number = params[:search][:address].split(' ')[0]
       a = JSON.parse( Geocoder.search(params[:search][:address].to_s, language: "vn").to_json )
        a.map { |hash| 
        @search.push("#{hash["data"]["address"].delete_if {|key, value| key == "postcode"  }.delete_if {|key, value| key == "country_code"}.values.join(',')}")
       }
     end

     if params[:location] != nil  
        @location = Geocoder.search(params[:location][:address]).first.coordinates
        @ship = (Geocoder::Calculations.distance_between([10.80076,106.679557], @location.to_a)).ceil(1) 
     end

     if params[:maps] != nil
      @place = Place.new
     @place.name = Geocoder.address("#{params[:maps][:latitude].to_s},#{params[:maps][:longitude].to_s}", language: "vn").gsub(/\b&#39\b/, 'dog')
     end
     # @place.name = Geocoder.search(Geocoder.address("#{params[:maps][:latitude].to_s},#{params[:maps][:longitude].to_s}")).to_a
  end

  # POST /places
  # POST /places.json
  def create
    # JSON.parse(Geocoder.search(params[:place][:name], language: "vn").to_json)[0]["data"]["address"].delete_if {|key, value| key == "postcode"  }.delete_if {|key, value| key == "country_code"}.values.join(',')
    @place = Place.new(place_params)
    if Geocoder.search(params[:place][:name]).length >= 1
        @place.name = params[:place][:name]
        @place.latitude =Geocoder.search(params[:place][:name]).first.coordinates[0].to_f
        @place.longitude =Geocoder.search(params[:place][:name]).first.coordinates[1].to_f
    else
       return 
    end
    debugger

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
       # @gcd = Geocoder.search(params[:name])

         params.require(:place).permit(:name, :latitude, :longitude)

    end
end
