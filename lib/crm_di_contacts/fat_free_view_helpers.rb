
module CRMDIContacts

  module FFViewHelpers

    def contact_side_bar_item(caption, id)
      "<div>#{caption}: <b style='color:#{lkup_color(id)}'>#{lkup_ld(id)}</b></div>" unless id.nil?
    end

  end

end

ActionView::Base.send(:include, CRMDIContacts::FFViewHelpers)
