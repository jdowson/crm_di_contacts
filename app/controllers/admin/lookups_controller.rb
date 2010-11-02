
class Admin::LookupsController < Admin::ApplicationController

  # unloadable

  before_filter :set_current_tab, :only => [ :index, :show ]
  before_filter :auto_complete, :only => :auto_complete

  
  #----------------------------------------------------------------------------
  # GET /admin/lookups/1
  # GET /admin/lookups/1.xml
  #----------------------------------------------------------------------------
  def show
    @lookup =  Lookup.find(params[:id])
    @lookups = get_child_lookups(@lookup, :page => params[:page])

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @lookup }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:html, :xml)
  end

  
  #----------------------------------------------------------------------------
  # GET /admin/lookups
  # GET /admin/lookups.xml                                                 HTML
  #----------------------------------------------------------------------------
  def index

    @lookups = get_lookups(:page => params[:page])

    respond_to do |format|
      format.html # index.html.haml
      format.js   # index.js.rjs
      format.xml  { render :xml => @lookups }
    end

  end


  #----------------------------------------------------------------------------
  # GET /admin/lookups/1/edit                                              AJAX
  #----------------------------------------------------------------------------
  def edit

    @lookup = Lookup.find(params[:id])

    if params[:previous] =~ /(\d+)\z/
      @previous = Lookup.find($1)
    end

  rescue ActiveRecord::RecordNotFound
    @previous ||= $1.to_i
    respond_to_not_found(:js) unless @lookup
  end


  #----------------------------------------------------------------------------
  # PUT /admin/lookups/1
  # PUT /admin/lookups/1.xml                                               AJAX
  #----------------------------------------------------------------------------
  def update
    @lookup = Lookup.find(params[:id])
 
    respond_to do |format|
      if @lookup.update_attributes(params[:lookup])
        format.js   # update.js.rjs
        format.xml  { head :ok }
      else
        format.js   # update.js.rjs
        format.xml  { render :xml => @lookup.errors, :status => :unprocessable_entity }
      end
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
  #----------------------------------------------------------------------------
  # GET /admin/lookups/new
  # GET /admin/lookups/new.xml                                             AJAX
  #----------------------------------------------------------------------------
  def new

    if(params[:id] && !params[:id].empty?)
      @lookup = Lookup.find(params[:id]).lookups.new
    else
      @lookup = Lookup.new
    end

    respond_to do |format|
      format.js   # new.js.rjs
      format.xml  { render :xml => @lookup }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end


  #----------------------------------------------------------------------------
  # POST /admin/lookups
  # POST /admin/lookups.xml                                                AJAX
  #----------------------------------------------------------------------------
  def create
    @lookup = Lookup.new(params[:lookup])

    respond_to do |format|
      if @lookup.save
        @lookups = get_lookups
        format.js   # create.js.rjs
        format.xml  { render :xml => @lookup, :status => :created, :location => @lookup }
      else
        format.js   # create.js.rjs
        format.xml  { render :xml => @lookup.errors, :status => :unprocessable_entity }
      end
    end
  end


  #----------------------------------------------------------------------------
  # PUT /admin/lookups/1/unpublish
  # PUT /admin/lookups/1/unpublish.xml                                     AJAX
  #----------------------------------------------------------------------------
  def unpublish
    @lookup = Lookup.find(params[:id])
    @lookup.unpublish!
    
    respond_to do |format|
      format.js   # unpublish.js.rjs
      format.xml  { render :xml => @lookup }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
  #----------------------------------------------------------------------------
  # PUT /admin/lookups/1/publish
  # PUT /admin/lookups/1/publish.xml                                       AJAX
  #----------------------------------------------------------------------------
  def publish
    @lookup = Lookup.find(params[:id])
    @lookup.activate!
    
    respond_to do |format|
      format.js   # publish.js.rjs
      format.xml  { render :xml => @lookup }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
  #----------------------------------------------------------------------------
  # PUT /admin/lookups/1/inactivate
  # PUT /admin/lookups/1/inactivate.xml                                    AJAX
  #----------------------------------------------------------------------------
  def inactivate
    @lookup = Lookup.find(params[:id])
    @lookup.inactivate!
    
    respond_to do |format|
      format.js   # publish.js.rjs
      format.xml  { render :xml => @lookup }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
  #----------------------------------------------------------------------------
  # PUT /admin/lookups/1/activate
  # PUT /admin/lookups/1/activate.xml                                      AJAX
  #----------------------------------------------------------------------------
  def activate
    
    # Don't move straight to 'Active'
    unpublish
  end

  
  #----------------------------------------------------------------------------
  # GET /admin/lookups/1/confirm                                           AJAX
  #----------------------------------------------------------------------------
  def confirm
    @lookup = Lookup.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
  #----------------------------------------------------------------------------
  # DELETE /admin/lookups/1
  # DELETE /admin/lookups/1.xml                                            AJAX
  #----------------------------------------------------------------------------
  def destroy
    @lookup = Lookup.find(params[:id])

    respond_to do |format|
      if @lookup.destroy
        format.js   # destroy.js.rjs
        format.xml  { head :ok }
      else
        flash[:warning] = t('di.lookups.msg_cant_delete', @lookup.name)
        format.js   # destroy.js.rjs
        format.xml  { render :xml => @lookup.errors, :status => :unprocessable_entity }
      end
    end
  end


  private

  #----------------------------------------------------------------------------
  def get_lookups(options = { :page => nil, :query => nil })

    self.current_page  = options[:page]  if options[:page]
    self.current_query = options[:query] if options[:query]

    if current_query.blank?
      Lookup.root_lookups.paginate(:page => current_page)
    else
      Lookup.root_lookups.search(current_query).paginate(:page => current_page)
    end

  end

  
  #----------------------------------------------------------------------------
  def get_child_lookups(parent, options = { :page => nil, :query => nil })

    self.current_page  = options[:page]  if options[:page]
    self.current_query = options[:query] if options[:query]

    if current_query.blank?
      parent.lookups.paginate(:page => current_page)
    else
      parent.lookups.search(current_query).paginate(:page => current_page)
    end

  end

  
end