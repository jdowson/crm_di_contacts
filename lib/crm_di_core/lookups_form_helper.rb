require "rubygems"
require "rexml/document"

module ActionView

  module Helpers

    def lookup_select_default_options(lookup = nil, test_for_groupings = true)

      l = { :parent_id         => nil, 
            :no_observer       => false,
            :lookup_options    => {
              :option_key_type        => :id, 
              :option_value_type      => :description,
              :group_label_type       => :description,
              :hide_groups            => false,
              :include_blank_if_empty => true,
              :hide_element           => nil,
              :select_first           => true,
              :cascade                => true,
              :parent_group           => false
            } 
          }

      p = lookup.is_a?(Hash) ? lookup : { :lookup => lookup, :lookup_options => {  } }
      lo = l[:lookup_options].merge(p.has_key?(:lookup_options) ? p[:lookup_options] : {})
      l.merge!(p)

      l[:lookup_options].merge!(lo)
      
      if test_for_groupings
        l[:lookup_options][:has_groupings]  = DILookupCache.has_groupings?(l[:lookup], l[:parent_id])
        l[:lookup_options][:show_groupings] = (l[:lookup_options][:parent_group] || l[:lookup_options][:has_groupings]) && !l[:lookup_options][:hide_groups]
      end

      l
      
    end

    
    def lookup_select_choices(l)

      if(!l[:lookup_options][:parent_group])
        if l[:lookup_options][:has_groupings] && !l[:lookup_options][:hide_groups]
          choices = DILookupCache.l_groupoptions(l[:lookup], l[:parent_id], l[:lookup_options][:option_key_type], l[:lookup_options][:option_value_type], l[:lookup_options][:group_label_type])
        else
          choices = DILookupCache.l_options(l[:lookup], l[:parent_id], l[:lookup_options][:option_key_type], l[:lookup_options][:option_value_type])        
        end
      else
        choices = DILookupCache.l_groupoptionsbyparent(l[:lookup], l[:parent_id], l[:lookup_options][:option_key_type], l[:lookup_options][:option_value_type], l[:lookup_options][:group_label_type])
      end

    end
    
    
    def lookup_select_tag(name, lookup, value = nil, options = {})

      l         = lookup_select_default_options(lookup)
      choices   = lookup_select_choices(l)
      observer  = ""
      html_name = (options[:multiple] == true && !name.to_s.ends_with?("[]")) ? "#{name}[]" : name

      if l[:lookup_options][:show_groupings]
        option_tags = grouped_options_for_select(choices, value)
      else
        option_tags = options_for_select(choices, value)
      end

      html      = content_tag :select, option_tags, { "name" => html_name, "id" => sanitize_to_id(name) }.update(options.stringify_keys)

      if !(l[:parent_control].nil? || l[:no_observer])
        this_control_id = sanitize_to_id(name)
        parent_control_id = l[:parent_control]
        observer = parent_lookup_observer(parent_control_id, this_control_id, l[:lookup], l[:lookup_options], options)
      end
      
      html << observer

    end

    
    def lookup_select(object, method, lookup, options = {}, html_options = {})

      l        = lookup_select_default_options(lookup)
      choices  = lookup_select_choices(l)
      observer = ""
      html     = ""
      
      if l[:lookup_options][:show_groupings]
        html = InstanceTag.new(object, method, self, options.delete(:object)).to_grouped_select_tag(choices, options, html_options)
      else
        html = InstanceTag.new(object, method, self, options.delete(:object)).to_select_tag(choices, options, html_options)
      end

      if !((l[:parent].nil? && l[:parent_control].nil?) || l[:no_observer])
        this_control_id = REXML::Document.new(html).root.attributes["id"]
        parent_control_id = l[:parent_control] ||= (object.to_s + "_" + l[:parent].to_s)
        observer = parent_lookup_observer(parent_control_id, this_control_id, l[:lookup], l[:lookup_options], options)
      end

      html << observer

    end

    
    class FormBuilder

      def lookup_select(method, lookup, options = {}, html_options = {})
        
        l = { :parent_id         => nil,
              :parent            => nil,
              :parent_control    => nil,
              :lookup_options    => { } 
          }.merge(lookup.is_a?(Hash) ? lookup : { :lookup => lookup })

        if !l[:parent].nil? && l[:parent_id].nil? 
          l[:parent_id] = (@object.nil? || !@object.respond_to?(l[:parent]) ? nil : @object.send(l[:parent])) 
        end

        @template.lookup_select(@object_name, method, l, objectify_options(options), @default_options.merge(html_options))
        
      end
      
    end

    
    class InstanceTag #:nodoc:
      include FormOptionsHelper

      def to_grouped_select_tag(choices, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        value = value(object)
        selected_value = options.has_key?(:selected) ? options[:selected] : value
        disabled_value = options.has_key?(:disabled) ? options[:disabled] : nil
        content_tag("select", add_options(grouped_options_for_select(choices, :selected => selected_value, :disabled => disabled_value), options, selected_value), html_options)
      end

    end

    
  end
  
end
