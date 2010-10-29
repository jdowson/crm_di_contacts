sendd __FILE__, "Booting"

module CrmDICore

  module FFViewHelpers

    def side_bar_item(c, s)
      "#{c}: <b>#{s}</b>"
    end

  end
end

ActionView::Base.send(:include, CrmDICore::FFViewHelpers)
 
