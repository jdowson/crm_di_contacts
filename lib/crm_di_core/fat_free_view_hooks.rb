sendd __FILE__, "Booting"

class DICoreFFViewHooks < FatFreeCRM::Callback::Base

  # Some HAML fragments
  
  # New fields for contact object
  HAML_MONGNESSFIELD = <<EOS
%tr
  %td{ :valign => :top, :colspan => span }
    .label.req Mongness: <small>(how much of a mong?)</small>
    = f.text_field :mongness, :style => "width:200px"
EOS


  HAML_MONGNESSSIDEBAR = <<EOS
.mongnessItem= side_bar_item("Mongness", model.mongness)
EOS


  INLINE_STYLES_LOOKUPS_INDEX = <<EOS
li.lookup .active
    :background lightgreen
li.lookup .unpublished
    :background lightblue
li.lookup .inactive
    :background gainsboro
EOS

  # Install inline style hook
  def inline_styles(view, context = {})

    if(view.controller.controller_name == 'lookups')

      if(view.controller.action_name == 'index' || view.controller.action_name == 'show')
        Sass::Engine.new(INLINE_STYLES_LOOKUPS_INDEX).render
      end

    end

  end

  # Install view hooks for models
  [ :contact ].each do |model|

    define_method :"#{model}_top_section_bottom" do |view, context|
      sendd __FILE__, "Hook Start #{model}_top_section_bottom"
      Haml::Engine.new(HAML_MONGNESSFIELD).render(view, :f => context[:f], :span => 3)
    end

    define_method :"show_#{model}_sidebar_bottom" do |view, context|
      sendd __FILE__, "Hook Start show_#{model}_sidebar_bottom"
      unless context[model].mongness.nil?
        Haml::Engine.new(HAML_MONGNESSSIDEBAR).render(view, :model => context[model])
      end
    end

  end

  
end

# class DICoreFFViewHooks < FatFreeCRM::Callback::Base
# 
#   TAGS_FIELD = <<EOS
# %tr
#   %td{ :valign => :top, :colspan => span }
#     .label.req Tags: <small>(comma separated, letters and digits only)</small>
#     = f.text_field :tag_list, :style => "width:500px"
# EOS
# 
#   TAGS_FOR_INDEX = <<EOS
# %dt
#   .tags= tags_for_index(model)
# EOS
# 
#   TAGS_FOR_SHOW = <<EOS
# .tags(style="margin:4px 0px 4px 0px")= tags_for_show(model)
# EOS
# 
#   TAGS_STYLES = <<EOS
# .tags, .list li dt .tags
#   a:link, a:visited
#     :background lightsteelblue
#     :color white
#     :font-weight normal
#     :padding 0px 6px 1px 6px
#     :-moz-border-radius 8px
#     :-webkit-border-radius 8px
#   a:hover
#     :background steelblue
#     :color yellow
# EOS
# 
#   TAGS_JAVASCRIPT = <<EOS
# crm.search_tagged = function(query, controller) {
#   if ($('query')) {
#     $('query').value = query;
#   }
#   crm.search(query, controller);
# }
# EOS
# 
#   #----------------------------------------------------------------------------
#   def inline_styles(view, context = {})
#     Sass::Engine.new(TAGS_STYLES).render
#   end
# 
#   #----------------------------------------------------------------------------
#   def javascript_epilogue(view, context = {})
#     TAGS_JAVASCRIPT
#   end
# 
#   #----------------------------------------------------------------------------
#   [ :account, :campaign, :contact, :lead, :opportunity ].each do |model|
# 
#     define_method :"#{model}_top_section_bottom" do |view, context|
#       #Haml::Engine.new(TAGS_FOR_SHOW).render(view, :model => context[model])
#       Haml::Engine.new(TAGS_FIELD).render(view, :f => context[:f], :span => (model != :campaign ? 3 : 5))
#     end
# 
#     define_method :"#{model}_bottom" do |view, context|
#       unless context[model].tag_list.empty?
#         Haml::Engine.new(TAGS_FOR_INDEX).render(view, :model => context[model])
#       end
#     end
# 
#     define_method :"show_#{model}_sidebar_bottom" do |view, context|
#       unless context[model].tag_list.empty?
#         Haml::Engine.new(TAGS_FOR_SHOW).render(view, :model => context[model])
#       end
#     end
# 
#   end
# 
# end 
