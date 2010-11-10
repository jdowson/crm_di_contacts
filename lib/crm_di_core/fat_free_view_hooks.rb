
sendd __FILE__, "Booting"

class DICoreFFViewHooks < FatFreeCRM::Callback::Base

  # Some HAML fragments
  
  # New fields for contact object
  HAML_MONGNESSFIELD = <<EOS
%tr
  %td{ :valign => :top, :colspan => span }
    .label.req Mongness: <small>(how much of a mong?)</small>
    - DILookupCache.load unless DILookupCache.loaded?
    = f.select :mongness, options_for_select(DILookupCache.l_options("color"), @contact.mongness), { :include_blank => false }, { :style => "width:240px" }

EOS
#collection_select(:post, :category_id, Category.all, :id, :name)
#    = f.text_field :mongness, :style => "width:200px"
#options_from_collection_for_select(Lookup.all, 'id', 'name', @contact.mongness)
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
li.lookup_item .active
    :background lightgreen
li.lookup_item .unpublished
    :background lightblue
li.lookup_item .inactive
    :background gainsboro
div .disubform
    :background gainsboro
    :margin-bottom 4px
    :margin-top 4px
    :padding-left 4px
    :padding-right 4px
    :border 1px solid darkgray
div .discope
    :background antiquewhite
    :margin 4px
    :padding 4px
    :border 1px solid darkgray
    :font-size 0.8em
div .discopeside
    :background antiquewhite
    :margin 2px
    :padding 4px
    :border 1px solid darkgray
    :font-size 1.0em
EOS

  # Install inline style hook
  def inline_styles(view, context = {})

    if(view.controller.action_name == 'index' || view.controller.action_name == 'show')
      styles = case view.controller.controller_name
        when "lookups"      then INLINE_STYLES_LOOKUPS
        when "lookup_items" then INLINE_STYLES_LOOKUPS
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
