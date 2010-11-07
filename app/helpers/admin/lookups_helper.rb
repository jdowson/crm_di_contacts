
module Admin::LookupsHelper

  #----------------------------------------------------------------------------
  def link_to_confirm(lookup)
    link_to_remote(t(:delete, :scope=> [:di]) + "?", :method => :get, :url => confirm_admin_lookup_path(lookup))
  end

  #----------------------------------------------------------------------------
  def link_to_activate(lookup)
    link_to_remote(t(:activate, :scope=> [:di]) + "!", :method => :put, :url => activate_admin_lookup_path(lookup))
  end

  #----------------------------------------------------------------------------
  def link_to_inactivate(lookup)
    link_to_remote(t(:inactivate, :scope=> [:di]) +"!", :method => :put, :url => inactivate_admin_lookup_path(lookup))
  end

  #----------------------------------------------------------------------------
  def link_to_publish(lookup)
    link_to_remote(t(:publish, :scope=> [:di]) + "!", :method => :put, :url => publish_admin_lookup_path(lookup))
  end

  #----------------------------------------------------------------------------
  def link_to_unpublish(lookup)
    link_to_remote(t(:unpublish, :scope=> [:di]) +"!", :method => :put, :url => unpublish_admin_lookup_path(lookup))
  end

  #----------------------------------------------------------------------------
  def link_to_parents(lookup)
    p = lookup.parent
    s = ""

    until p.nil?
      s = link_to(h(p.name), admin_lookup_path(p)) << (s.empty? ? "" : " | ") << s
      p = p.parent
    end
    
    s
  end
  
  #----------------------------------------------------------------------------
  def link_to_delete(lookup)
    link_to_remote(t(:yes_button), 
      :method => :delete,
      :url => admin_lookup_path(lookup),
      :before => visual_effect(:highlight, dom_id(lookup), :startcolor => "#ffe4e1")
    )
  end

end
 
