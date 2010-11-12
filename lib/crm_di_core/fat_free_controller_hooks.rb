
sendd __FILE__, "Booting"

class DICoreFFControllerHooks < FatFreeCRM::Callback::Base

  # Install inline style hook
  # attaching to: ApplicationController:before_filter "hook(:app_before_filter, self)"
  define_method :"app_before_filter" do |controller, context|

    # Ensure lookup cache loaded
    DILookupCache.load unless DILookupCache.loaded?  

  end
  
end
 
