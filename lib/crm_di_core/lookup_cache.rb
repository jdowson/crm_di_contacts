
sendd __FILE__, "Booting"

class DILookupCache

  @cache_loaded = false
  @lookup_cache = {}
  @lookup_item_cache = {}

  # Cache management methods
  # ---------------------------------------------------------------------
  def self.loaded?
    @cache_loaded
  end
  
  def self.load
    if !self.loaded?

      Lookup.find_all_by_status("Active").each do |l| 
        @lookup_cache[l.name] = { 
                                  :id          => l.id,
                                  :name        => l.name, 
                                  :description => l.description, 
                                  :type        => l.lookup_type,
                                  :parent      => l.parent_id.nil? ? nil : l.parent.name
                                }
      end

      LookupItem.find_all_by_status("Active").each do |i| 
        @lookup_item_cache[i.unique_code] = { 
                                  :id          => i.id,
                                  :lookup_id   => i.lookup_id,
                                  :parent_id   => i.parent_id,
                                  :code        => i.code,
                                  :unique_code => i.unique_code,
                                  :description => i.description,
                                  :long_desc   => i.long_description,
                                  :type        => i.item_type,
                                  :color       => i.html_color,
                                  :locales     => {}
                                }
      end

      LookupItemLocale.all.each do |l| 
        items = @lookup_item_cache.select {|k, v| v[:id] == l.lookup_item_id}
        if(items.size == 1)
          items.values.first[:locales][l.language] = { 
                                  :description => l.description,
                                  :long_desc   => l.long_description,
                                }
        end
      end
      
      @cache_loaded = true

    end
    
  end
  
  
  # Base cache access methods
  # ---------------------------------------------------------------------
  def self.unload
    @lookup_cache.clear
    @cache_loaded = false
  end
  
  
  def self.reload
    self.unload
    self.load
  end

  
  def self.cache
    @lookup_cache
  end
  
  
  def self.item_cache
    @lookup_item_cache
  end
  
  
  # Cache access methods
  # ---------------------------------------------------------------------
  def self.u_itemdesc(lookup_name, code, parent_id = nil)
    if i = self.item(lookup_name, code, parent_id)
      i[:description]
    end
  end
  
  def self.l_itemdesc(lookup_name, code, parent_id = nil, locale = nil)
    if i = localized_item(self.item(lookup_name, code, parent_id), locale ||= I18n.locale  ||= I18n.default_locale)
      i[:description]
    end
  end
 
  def self.u_item(lookup_name, code, parent_id = nil)
    if i = self.item(lookup_name, code, parent_id)
      i.reject {|k, v| k == :locales}
    end
  end
  
  def self.l_item(lookup_name, code, parent_id = nil, locale = nil)
    localized_item(self.item(lookup_name, code, parent_id), locale ||= I18n.locale  ||= I18n.default_locale)
  end
 
  def self.u_items(lookup_name, parent_id = nil)
    if a = self.items(lookup_name, parent_id)
      a.map { |i| i.reject {|k, v| k == :locales} }
    end
  end
  
  def self.l_items(lookup_name, parent_id = nil, locale = nil)
    if a = self.items(lookup_name, parent_id)
      a.map { |i| localized_item(i, locale ||= I18n.locale  ||= I18n.default_locale) }
    end
  end


  private
  
  def self.item(lookup_code, code, parent_id = nil)
    if lookup = @lookup_cache[lookup_code]
      @lookup_item_cache[lookup[:id].to_s << ":" << nilz(parent_id).to_s << ":" << code]
    end
  end

  def self.items(lookup_name, parent_id = nil)
    if lookup = @lookup_cache[lookup_name]
      @lookup_item_cache.select {|k, v| (v[:lookup_id] == lookup[:id]) && (v[:parent_id] == parent_id)}.values
    end
  end
  
  def self.localized_item(item, locale)
    if(item)
      li = item.dup
      locales = li.delete(:locales)
      li.merge(locales[locale.to_s] ||= {})
    end
  end
  
end
 
 
