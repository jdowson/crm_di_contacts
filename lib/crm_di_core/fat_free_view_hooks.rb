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


  INLINE_STYLES_LOOKUPS = <<EOS
li.lookup .active
    :background lightgreen
li.lookup .unpublished
    :background lightblue
li.lookup .inactive
    :background gainsboro
EOS

  INLINE_STYLES_LOOKUP_ITEMS = <<EOS
li.lookup_item .active
    :background lightgreen
li.lookup_item .unpublished
    :background lightblue
li.lookup_item .inactive
    :background gainsboro
EOS

  # Install inline style hook
  def inline_styles(view, context = {})

    if(view.controller.action_name == 'index' || view.controller.action_name == 'show')
      styles = case view.controller.controller_name
        when "lookups"      then INLINE_STYLES_LOOKUPS
        when "lookup_items" then INLINE_STYLES_LOOKUP_ITEMS
        else ""
      end
    end

    Sass::Engine.new(styles).render unless styles.empty?

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
