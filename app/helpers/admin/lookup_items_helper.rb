
module Admin::LookupItemsHelper

  #----------------------------------------------------------------------------
  def html_description(lookup_item)
    lookup_item.description.blank? ? "<i>[#{t :empty_description, :scope=> [:di, :lookups, :items]}]</i>" : h(lookup_item.description)
  end
  
  #----------------------------------------------------------------------------
  def link_to_edit(lookup_item)
    link_to_remote(t(:edit), :method => :get, :url => edit_admin_child_lookup_item_path(lookup_item.lookup_id, nilz(lookup_item.parent_id), lookup_item))
  end

  #----------------------------------------------------------------------------
  def link_to_moveup(lookup_item)
    link_to_remote(t(:move_up, :scope=> [:di]) + "!", :method => :put, :url => moveup_admin_child_lookup_item_path(lookup_item.lookup_id, nilz(lookup_item.parent_id), lookup_item))
  end

  #----------------------------------------------------------------------------
  def link_to_movedown(lookup_item)
    link_to_remote(t(:move_down, :scope=> [:di]) + "!", :method => :put, :url => movedown_admin_child_lookup_item_path(lookup_item.lookup_id, nilz(lookup_item.parent_id), lookup_item))
  end

  #----------------------------------------------------------------------------
  def link_to_confirm(lookup_item)
    link_to_remote(t(:delete, :scope=> [:di]) + "?", :method => :get, :url => confirm_admin_child_lookup_item_path(lookup_item.lookup_id, nilz(lookup_item.parent_id), lookup_item))
  end

  #----------------------------------------------------------------------------
  def link_to_activate(lookup_item)
    link_to_remote(t(:activate, :scope=> [:di]) + "!", :method => :put, :url => activate_admin_child_lookup_item_path(lookup_item.lookup_id, nilz(lookup_item.parent_id), lookup_item))
  end

  #----------------------------------------------------------------------------
  def link_to_inactivate(lookup_item)
    link_to_remote(t(:inactivate, :scope=> [:di]) +"!", :method => :put, :url => inactivate_admin_child_lookup_item_path(lookup_item.lookup_id, nilz(lookup_item.parent_id), lookup_item))
  end

  #----------------------------------------------------------------------------
  def link_to_publish(lookup_item)
    link_to_remote(t(:publish, :scope=> [:di]) + "!", :method => :put, :url => publish_admin_child_lookup_item_path(lookup_item.lookup_id, nilz(lookup_item.parent_id), lookup_item))
  end

  #----------------------------------------------------------------------------
  def link_to_unpublish(lookup_item)
    link_to_remote(t(:unpublish, :scope=> [:di]) +"!", :method => :put, :url => unpublish_admin_child_lookup_item_path(lookup_item.lookup_id, nilz(lookup_item.parent_id), lookup_item))
  end

  #----------------------------------------------------------------------------
  def link_to_parents(lookup_item)
    p = lookup_item.parent
    s = ""

    until p.nil?
      s = link_to(h(p.name), admin_child_lookup_item_path(p)) << (s.empty? ? "" : " | ") << s
      p = p.parent
    end
    
    s
  end
  
  #----------------------------------------------------------------------------
  def link_to_delete(lookup_item)
    link_to_remote(t(:yes_button), 
      :method => :delete,
      :url => admin_child_lookup_item_path(lookup_item.lookup_id, nilz(lookup_item.parent_id), lookup_item),
      :before => visual_effect(:highlight, dom_id(lookup_item), :startcolor => "#ffe4e1")
    )
  end

end
 
 
