
class Admin::LookupItemsController < Admin::ApplicationController

  unloadable

  before_filter :set_current_tab, :only => [ :index, :show ]
  before_filter :auto_complete, :only => :auto_complete 

  
#   # Store current selection when using simple column search
#   #----------------------------------------------------------------------------
#   def current_selection=(selection)
#     @current_selection = session["#{controller_name}_current_selection".to_sym] = selection.to_i
#   end
# 
#   #----------------------------------------------------------------------------
#   def current_selection
#     selection = params[:id] || session["#{controller_name}_current_selection".to_sym] || 0
#     @current_selection = selection.to_i
#   end


#   #----------------------------------------------------------------------------
#   # GET /admin/lookups/1
#   # GET /admin/lookups/1.xml
#   #----------------------------------------------------------------------------
#   def show
# 
#     self.current_query = ''
#     
#     @lookup  = Lookup.find(params[:id])
#     @lookups = get_child_lookups(@lookup, :page => params[:page])
# 
#     respond_to do |format|
#       format.html # show.html.haml
#       format.xml  { render :xml => @lookup }
#     end
# 
#   rescue ActiveRecord::RecordNotFound
#     respond_to_not_found(:html, :xml)
#   end

  #----------------------------------------------------------------------------
  # GET /admin/lookup_items
  # GET /admin/lookup_items.xml                                            HTML
  #----------------------------------------------------------------------------
  def index

    self.current_query = ''

    @lookup_items = get_lookup_items_all(:page => params[:page])

    respond_to do |format|
      format.html # index.html.haml
      format.js   # index.js.rjs
      format.xml  { render :xml => @ites }
    end

  end


  #----------------------------------------------------------------------------
  # GET /admin/lookup_items/1/edit                                         AJAX
  #----------------------------------------------------------------------------
  def edit

    @lookup_item = LookupItem.find(params[:id])

    if params[:previous] =~ /(\d+)\z/
       @previous = LookupItem.find($1)
    end

  rescue ActiveRecord::RecordNotFound
    @previous ||= $1.to_i
    respond_to_not_found(:js) unless @lookup
  end


  #----------------------------------------------------------------------------
  # PUT /admin/lookup_items/1
  # PUT /admin/lookup_items/1.xml                                          AJAX
  #----------------------------------------------------------------------------
  def update
    @lookup_item = LookupItem.find(params[:id])
 
    respond_to do |format|
      if @lookup_item.update_attributes(params[:lookup_item])
        format.js   # update.js.rjs
        format.xml  { head :ok }
      else
        format.js   # update.js.rjs
        format.xml  { render :xml => @lookup_item.errors, :status => :unprocessable_entity }
      end
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
  #----------------------------------------------------------------------------
  # GET /admin/lookup_items/new
  # GET /admin/lookup_items/new.xml                                        AJAX
  #----------------------------------------------------------------------------
  def new

 #   if(params[:id] && !params[:id].empty?)
 #     @lookup = LookupItem.find(params[:id]).lookups.new
 #   else
      @lookup_item = LookupItem.new
      @lookup_item.lookup_id = 1
 #   end

    respond_to do |format|
      format.js   # new.js.rjs
      format.xml  { render :xml => @lookup }
    end

#  rescue ActiveRecord::RecordNotFound
#    respond_to_not_found(:js, :xml)
  end


  #----------------------------------------------------------------------------
  # POST /admin/lookup_items
  # POST /admin/lookup_items.xml                                           AJAX
  #----------------------------------------------------------------------------
  def create
    @lookup_item = LookupItem.new(params[:lookup_item])
    @lookup_item.assign_next_sequence
#page.insert_html :bottom, :lookup_items, :partial => "lookup_item", :collection => [ @lookup_item ]
    
    
    respond_to do |format|
      if @lookup_item.save
        @lookup_items = get_lookup_items(@lookup_item.siblings, :page => params[:page])
        #FROM OLD PARTIAL @lookups = @lookup.parent.nil? ? get_root_lookups : get_child_lookups(@lookup.parent)
        format.js   # create.js.rjs
        format.xml  { render :xml => @lookup, :status => :created, :location => @lookup_item }
      else
        format.js   # create.js.rjs
        format.xml  { render :xml => @lookup.errors, :status => :unprocessable_entity }
      end
    end

  end


  #----------------------------------------------------------------------------
  # PUT /admin/lookup_items/1/unpublish
  # PUT /admin/lookup_items/1/unpublish.xml                                AJAX
  #----------------------------------------------------------------------------
  def unpublish
    @lookup_item = LookupItem.find(params[:id])
    @lookup_item.unpublish!
    
    respond_to do |format|
      format.js   # unpublish.js.rjs
      format.xml  { render :xml => @lookup_item }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

   
  #----------------------------------------------------------------------------
  # PUT /admin/lookup_items/1/publish
  # PUT /admin/lookup_items/1/publish.xml                                  AJAX
  #----------------------------------------------------------------------------
  def publish
    @lookup_item = LookupItem.find(params[:id])
    @lookup_item.activate!
    
    respond_to do |format|
      format.js   # publish.js.rjs
      format.xml  { render :xml => @lookup_item }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
  #----------------------------------------------------------------------------
  # PUT /admin/lookup_items/1/inactivate
  # PUT /admin/lookup_items/1/inactivate.xml                               AJAX
  #----------------------------------------------------------------------------
  def inactivate
    @lookup_item = LookupItem.find(params[:id])
    @lookup_item.inactivate!
    
    respond_to do |format|
      format.js   # publish.js.rjs
      format.xml  { render :xml => @lookup_item }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
  #----------------------------------------------------------------------------
  # PUT /admin/lookup_items/1/activate
  # PUT /admin/lookup_items/1/activate.xml                                 AJAX
  #----------------------------------------------------------------------------
  def activate
    
    # Don't move straight to 'Active'
    unpublish
  end

  
  #----------------------------------------------------------------------------
  # GET /admin/lookup_items/1/confirm                                      AJAX
  #----------------------------------------------------------------------------
  def confirm
    @lookup_item = LookupItem.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
  #----------------------------------------------------------------------------
  # DELETE /admin/lookup_items/1
  # DELETE /admin/lookup_items/1.xml                                       AJAX
  #----------------------------------------------------------------------------
  def destroy

    @lookup_item = LookupItem.find(params[:id])

    respond_to do |format|
      if @lookup_item.destroy
        format.js   # destroy.js.rjs
        format.xml  { head :ok }
      else
        flash[:warning] = t('di.lookups.items.msg_cant_delete', @lookup_item.description)
        format.js   # destroy.js.rjs
        format.xml  { render :xml => @lookup_item.errors, :status => :unprocessable_entity }
      end
    end
  end


  #----------------------------------------------------------------------------
  # PUT /admin/lookup_items/1/moveup
  # PUT /admin/lookup_items/1/moveup.xml                                   AJAX
  #----------------------------------------------------------------------------
  def moveup
    @lookup_item = LookupItem.find(params[:id])
    @lookup_item.move_up!
    
    @lookup_items = get_lookup_items @lookup_item.siblings
    
    respond_to do |format|
      format.js   { render :action => :index }
      format.xml  { render :xml => @lookup_items }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
  #----------------------------------------------------------------------------
  # PUT /admin/lookup_items/1/movedown
  # PUT /admin/lookup_items/1/movedown.xml                                 AJAX
  #----------------------------------------------------------------------------
  def movedown
    @lookup_item = LookupItem.find(params[:id])
    @lookup_item.move_down!
    
    @lookup_items = get_lookup_items @lookup_item.siblings
    
    respond_to do |format|
      format.js   { render :action => :index }
      format.xml  { render :xml => @lookup_items }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  
#   #----------------------------------------------------------------------------
#   # GET /admin/users/search/query                                          AJAX
#   #----------------------------------------------------------------------------
#   def search
# 
#     if(self.current_selection == 0)
#       @lookups = get_root_lookups(:query => params[:query], :page => 1)
#     else
#       @lookup  = Lookup.find(self.current_selection)
#       @lookups = get_child_lookups(@lookup, :query => params[:query], :page => 1)
#     end
#     
#     respond_to do |format|
#       format.js   { render :action => :index }
#       format.xml  { render :xml => @lookups.to_xml }
#     end
# 
#   rescue ActiveRecord::RecordNotFound
#     respond_to_not_found(:js, :xml)
#   end

  
  private

#   #----------------------------------------------------------------------------
#   def get_lookups(selection, options = { :page => nil, :query => nil })
# 
#     self.current_page      = options[:page]  if options[:page]
#     self.current_query     = options[:query] if options[:query]
# 
#     if current_query.blank?
#       selection.paginate(:page => current_page)
#     else
#       selection.search(current_query).paginate(:page => current_page)
#     end
# 
#   end
#     
#   #----------------------------------------------------------------------------
#   def get_root_lookups(options = { :page => nil, :query => nil })
#     self.current_selection = 0
#     get_lookups Lookup.root_lookups, options
#   end
# 
#   #----------------------------------------------------------------------------
#   def get_child_lookups(parent, options = { :page => nil, :query => nil })
#     self.current_selection = parent.id
#     get_lookups parent.lookups, options
#   end

  def get_lookup_items_all(options = { :page => nil, :query => nil })

    self.current_page      = options[:page]  if options[:page]
    self.current_query     = options[:query] if options[:query]

    if current_query.blank?
      LookupItem.all.paginate(:page => current_page)
    else
      LookupItem.all.search(current_query).paginate(:page => current_page)
    end

  end

  def get_lookup_items(lookup_items, options = { :page => nil, :query => nil })

    self.current_page      = options[:page]  if options[:page]
    self.current_query     = options[:query] if options[:query]

    if current_query.blank?
      lookup_items.paginate(:page => current_page)
    else
      lookup_items.search(current_query).paginate(:page => current_page)
    end

  end

end 
