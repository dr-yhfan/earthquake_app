class EarthquakesController < ApplicationController
  def index
  end
  
  def earthquakes
    present_param_items = params.select {|k, v| v.present? }
    if (present_param_items.keys & ['since', 'on', 'over', 'near']).blank?
      @records = Earthquake.all_ordered
    else
      @records = nil
      if params[:since].present? or params[:on].present?
        @records = Earthquake.since_time_until_day_of(params[:since], params[:on])
      end
      if params[:over].present?
        @records = (@records.present? ? @records.over_magnitude(params[:over]) : Earthquake.over_magnitude(params[:over]))
      end
      if params[:near].present?
        @records = (@records.present? ? @records.near_lat_lon(params[:near]) : Earthquake.near_lat_lon(params[:near]))
      end
    end
    
    respond_to do |format|
      format.html
      format.json { render json: @records}
    end
  end
end
