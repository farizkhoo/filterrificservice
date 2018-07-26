class ServicesController < ApplicationController
  def index
  	
    @filterrific = initialize_filterrific(
      Service,
      params[:filterrific],
      select_options: {
        sorted_by: Service.options_for_sorted_by,
        with_country_id: Country.options_for_select
      },
    ) or return
    
    @services = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end

  
  rescue ActiveRecord::RecordNotFound => e
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end
end
