
module CRMDICore

  module LookupsViewHelper

    def parent_lookup_observer(parent, child, lookup_name, lookup_options = {}, options = {})
      o = { :cascade => true, :select_first => true, :include_blank_if_empty => true, :blank_text => "", :hide_element => "" }
      o.merge! lookup_options

      observe_field parent, :url => { :controller => 'lookups', :action => 'get_children', :child => child, :lookup_name => lookup_name, :lookup_options => o, :options => options }, :method => :get, :with => "parent_id"
    end
    
    def lkup_d(id, locale = nil)
      DILookupCache.l_itemdesc(id, locale)
    end
 
    def lkup_ld(id, locale = nil)
      DILookupCache.l_itemldesc(id, locale)
    end
 
    def lkup_color(id)
      DILookupCache.itemcolor(id)
    end
 
    def lkup(id, locale = nil)
      DILookupCache.l_item(id, locale)
    end
 
    def lkups(lookup_name, parent_id = nil, locale = nil)
      DILookupCache.l_items(lookup_name, parent_id, locale)
    end

    def lkups_options(lookup_name, parent_id = nil, id = :id, description = :description, locale = nil)
      DILookupCache.l_options(lookup_name, parent_id, id, description, locale)
    end

    # Options related methods
    def options_or_groups_from_lookup_for_select(lookup_name, parent_id = nil, selected = nil)
      option_groups_from_lookup_for_select lookup_name, parent_id, selected
    end

    def option_groups_from_lookup_for_select(lookup_name, parent_id = nil, selected_key = nil, group_label_method = :description, option_key_method = :id, option_value_method = :description)
      if DILookupCache.has_groupings?(lookup_name, parent_id)
        options = DILookupCache.l_groupoptions(lookup_name, parent_id, id = option_key_method, description = option_value_method, groupdescription = group_label_method)
        grouped_options_for_select options, selected_key
      else
        options_from_lookup_for_select lookup_name, parent_id, selected_key, option_key_method, option_value_method
      end
    end

    def options_from_lookup_for_select(lookup_name, parent_id = nil, selected = nil, value_method = :id, text_method = :description)
      options_for_select DILookupCache.l_options(lookup_name, parent_id, value_method, text_method), selected
    end
    
  end

end

ActionView::Base.send(:include, CRMDICore::LookupsViewHelper)
