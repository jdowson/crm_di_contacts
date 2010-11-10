
sendd __FILE__, "Booting"

module CrmDICore

  module FFViewHelpers

    def side_bar_item(c, s)
      DILookupCache.load unless DILookupCache.loaded?
      "#{c}: <b style='color:#{DILookupCache.l_itemcolor("color", s)}'>#{DILookupCache.l_itemldesc("color", s)}</b>"
    end

  end
end

ActionView::Base.send(:include, CrmDICore::FFViewHelpers)
 
