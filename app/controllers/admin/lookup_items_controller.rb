
class Admin::LookupItemsController < Admin::ApplicationController

  unloadable

  before_filter "set_current_tab('lookups')", :only => [ :index, :show ]
  before_filter :auto_complete, :only => :auto_complete 


  #----------------------------------------------------------------------------
  # GET /admin/lookup_items
  # GET /admin/lookup_items.xml                                            HTML
  #----------------------------------------------------------------------------
  def index

    self.current_query = ''

    get_lookup_items params[:lookup_id], znil(params[:lookup_item_id]), :page => params[:page]

    respond_to do |format|
      format.html # index.html.haml
      format.js   # index.js.rjs
      format.xml  { render :xml => @lookup_items }
    end

  end


  #----------------------------------------------------------------------------
  # PUT /admin/lookup_items/1/publish_all
  # PUT /admin/lookup_items/1/publish_all.xml                              AJAX
  #----------------------------------------------------------------------------
  def publish_all

    get_lookup_items params[:lookup_id], znil(params[:lookup_item_id])
    
    @lookup_items.each do |item|
      item.activate! if item.unpublished?
    end

    respond_to do |format|
      format.js   { render :action => :index }
      format.xml  { render :xml => @lookup_items }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end


  #----------------------------------------------------------------------------
  # PUT /admin/lookup_items/1/sort_a_z_description
  # PUT /admin/lookup_items/1/sort_a_z_description.xml                     AJAX
  #----------------------------------------------------------------------------
  def sort_a_z_description

    get_lookup_items params[:lookup_id], znil(params[:lookup_item_id])

    @lookup_items.sort! { |a,b| a.description <=> b.description }
    
    i = 1
    
    @lookup_items.each do |item|
      item.update_attribute(:sequence, i) unless item.sequence == i
      i += 1
    end

    respond_to do |format|
      format.js   { render :action => :index }
      format.xml  { render :xml => @lookup_items }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end


  #----------------------------------------------------------------------------
  # PUT /admin/lookup_items/1/sort_a_z_code
  # PUT /admin/lookup_items/1/sort_a_z_code.xml                            AJAX
  #----------------------------------------------------------------------------
  def sort_a_z_code

    get_lookup_items params[:lookup_id], znil(params[:lookup_item_id])

    @lookup_items.sort! { |a,b| a.code <=> b.code }
    
    i = 1
    
    @lookup_items.each do |item|
      item.update_attribute(:sequence, i) unless item.sequence == i
      i += 1
    end

    respond_to do |format|
      format.js   { render :action => :index }
      format.xml  { render :xml => @lookup_items }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
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
      if @lookup_item.update_attributes(params[:lookup_item]) && save_locales(@lookup_item)
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

  def save_locales(lookup_item)

    saveok = true
    
    [
      params[:locale_languages], 
      params[:locale_descriptions], 
      params[:locale_long_descriptions]
    ].transpose.each do |l|

      language = l[0]

      if params[:locales] && params[:locales].include?(language)
        if lookup_item.locales.map(&:language).include?(language)
          saveok &&= lookup_item.locales.find_by_language(language).update_attributes(:description => l[1], :long_description => l[2])
        else
          saveok &&= lookup_item.locales.new(:language => language, :description => l[1], :long_description => l[2]).save
        end
      else
        if lookup_item.locales.map(&:language).include?(language)
          saveok &&= lookup_item.locales.find_by_language(language).destroy
        end
      end
      
    end
    
    saveok
    
  end
  
  #----------------------------------------------------------------------------
  # GET /admin/lookup_items/new
  # GET /admin/lookup_items/new.xml                                        AJAX
  #----------------------------------------------------------------------------
  def new

    @lookup_item = LookupItem.new
    @lookup_item.lookup_id = params[:lookup_id]
    @lookup_item.parent_id = znil(params[:lookup_item_id])
    
    respond_to do |format|
      format.js   # new.js.rjs
      format.xml  { render :xml => @lookup }
    end

  end


  #----------------------------------------------------------------------------
  # POST /admin/lookup_items
  # POST /admin/lookup_items.xml                                           AJAX
  #----------------------------------------------------------------------------
  def create
    @lookup_item = LookupItem.new(params[:lookup_item])
    @lookup_item.assign_next_sequence
    
    respond_to do |format|
      if @lookup_item.save && save_locales(@lookup_item)
        get_lookup_item_siblings @lookup_item, :page => params[:page]

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
      format.js   { render :action => :update_no_form }
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
      format.js   { render :action => :update_no_form }
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
      format.js   { render :action => :update_no_form }
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
        get_lookup_item_siblings @lookup_item, :page => params[:page]
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
    
    get_lookup_item_siblings @lookup_item, :page => params[:page]
    
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
    
    get_lookup_item_siblings @lookup_item, :page => params[:page]
    
    respond_to do |format|
      format.js   { render :action => :index }
      format.xml  { render :xml => @lookup_items }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end


  private

  def get_lookup_items(lookup_id, parent_id, options = { :page => nil, :query => nil })

    self.current_page      = options[:page]  if options[:page]
    self.current_query     = options[:query] if options[:query]

    @lookup_id = lookup_id
    @lookup = Lookup.find(@lookup_id)

    @parent_id = parent_id
    @parent = @parent_id.nil? ? nil : LookupItem.find(@parent_id)
    
    if current_query.blank?
      @lookup_items = @lookup.items_for_parent(@parent_id).paginate(:page => current_page)
    else
      @lookup_items = @lookup.items_for_parent(@parent_id).search(current_query).paginate(:page => current_page)
    end
  
  end

  def get_lookup_item_siblings(lookup_item, options = { :page => nil, :query => nil })
    get_lookup_items lookup_item.lookup_id, lookup_item.parent_id, options
  end
  
end 
