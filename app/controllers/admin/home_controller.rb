
# Only here to stub out base expected behaviour from outside the admin module
#------------------------------------------------------------------------------

class Admin::HomeController < Admin::ApplicationController
  before_filter :require_user, :except => [ :toggle, :timezone ]

  # GET /home/toggle                                                       AJAX
  #----------------------------------------------------------------------------
  def toggle
    ## params[:id] contains the id of the html element being toggled
    ## could use this to load on demand some stuff by rendering some rjs
    #if session[params[:id].to_sym]
    #  session.delete(params[:id].to_sym)
    #else
    #  session[params[:id].to_sym] = true
    #end
    render :nothing => true
  end

  # GET /home/timezone                                                     AJAX
  #----------------------------------------------------------------------------
  def timezone
    #
    # (new Date()).getTimezoneOffset() in JavaScript returns (UTC - localtime) in
    # minutes, while ActiveSupport::TimeZone expects (localtime - UTC) in seconds.
    #
    if params[:offset]
      session[:timezone_offset] = params[:offset].to_i * -60
      ActiveSupport::TimeZone[session[:timezone_offset]]
    end
    render :nothing => true
  end

end