class Admin::LookupsController < Admin::ApplicationController

  unloadable
  before_filter :set_current_tab
  
  def index
    # render views/admin/bananas/index.html.haml
  end

end
