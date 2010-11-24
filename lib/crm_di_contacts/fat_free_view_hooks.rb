
class DIContactsFFViewHooks < FatFreeCRM::Callback::Base

  # Some HAML fragments
  
  # New fields for contact object
  HAML_CONTACT_FORM_EXT = <<EOS
%tr
  %td{ :valign => :top, :colspan => span }
    %table(width="500" cellpadding="0" cellspacing="0")
      %tr
        %td{ :valign => :top }
          .label 
            = I18n.t(:type, :scope => [:di, :contacts]) << ":" 
            %small 
              = I18n.t(:type_help, :scope => [:di, :contacts])
          = f.lookup_select :contact_type_id, { :lookup_name => "contact.type", :include_blank_if_empty => "[No Types Created]" }, { :include_blank => "Select Type" }, { :style => "width:240px" }
        %td= spacer
        %td{ :valign => :top }
          #stype
            .label 
              = I18n.t(:sub_type, :scope => [:di, :contacts]) << ":"
            = f.lookup_select :contact_sub_type_id, { :lookup_name => "contact.type.subtype", :parent => :contact_type_id, :hide_element_if_empty => "stype", :disable_if_empty => true }, { }, { :style => "width:240px" }
      %tr
        %td{ :valign => :top }
          .label 
            = I18n.t(:type, :scope => [:di, :contacts]) << " (UNBOUND):" 
            %small 
              = I18n.t(:type_help, :scope => [:di, :contacts])
          = lookup_select_tag :ucontact_type_id, { :lookup_name => "contact.type", :option_key_type => :code, :include_blank_if_empty => "[No Types Created]", :include_blank => "Select Type" }, @contact.contact_type_id, { :style => "width:240px" }
        %td= spacer
        %td{ :valign => :top }
          #stype2
            .label 
              = I18n.t(:sub_type, :scope => [:di, :contacts]) << " (UNBOUND):"
            = lookup_select_tag :ucontact_sub_type_id, { :lookup_name => "contact.type.subtype", :parent_id => @contact.contact_type_id, :include_blank_if_empty => "NO STYPES", :parent_control => :ucontact_type_id, :parent_key_type => :code, :hide_element_if_empty => "stype2", :disable_if_empty => true }, @contact.contact_sub_type_id, { :style => "width:240px" }
EOS

  HAML_CONTACT_SIDEBAR_EXT = <<EOS
= contact_side_bar_item(t(:type,     :scope => [:di, :contacts]), model.contact_type_id)
= contact_side_bar_item(t(:sub_type, :scope => [:di, :contacts]), model.contact_sub_type_id)
EOS

  # Install view hooks for models
  [ :contact ].each do |model|

    define_method :"#{model}_top_section_bottom" do |view, context|
      sendd __FILE__, "Hook Start #{model}_top_section_bottom"
      Haml::Engine.new(HAML_CONTACT_FORM_EXT).render(view, :f => context[:f], :span => 3)
    end

    define_method :"show_#{model}_sidebar_bottom" do |view, context|
      sendd __FILE__, "Hook Start show_#{model}_sidebar_bottom"
      Haml::Engine.new(HAML_CONTACT_SIDEBAR_EXT).render(view, :model => context[model])
    end

  end
  
end
