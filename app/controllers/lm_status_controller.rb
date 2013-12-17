class LmStatusController < ApplicationController

  protect_from_forgery except: :create

  # create log from json post
  # this can be used from an external lm server with a line like the following:
  # curl --form apikey=YOUR_API_KEY [--form time=1386575821] --form logfile=LOG_DIR/1386575821.log -f -i -X POST SERVER_ADDRESS/lm_status.json
  # POST /lm_status.json
  def create
    respond_to do |format|
      format.json do
        ak=params[:apikey]
        if ak.nil? || ak != ENV['API_KEY']
          render :json => "ERR", :status => :unauthorized
        else
          s=LmStatus.new params.permit([:time, :features, :logfile])
          if s.save
            render :json => "OK!"
          else
            render :json => "ERR", :status => :bad_request
          end
        end
      end
    end
  end
end
