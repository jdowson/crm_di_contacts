
class LookupsController < ApplicationController

  #----------------------------------------------------------------------------
  # GET lookups/get_children                                               HTML
  #----------------------------------------------------------------------------
  def get_children

    @parent         = params[:parent_id].split(":")
    @parent_id      = @parent.size == 1 ? @parent.first.to_i : nil # should support unique_code too
    @lookup_name    = params[:lookup_name]
    @child          = params[:child]
    @options        = params[:options] ||= { }
    @lookup_options = params[:lookup_options] ||= { }

    l               = @lookup_options
    first_value     = nil

    if (l[:parent_group].to_sym != :true)

      if DILookupCache.has_groupings?(@lookup_name, @parent_id) && !(l[:hide_groups].to_sym == :true)

        @values = DILookupCache.l_groupoptions(@lookup_name, @parent_id, l[:option_key_type].to_sym, l[:option_value_type].to_sym, l[:group_label_type].to_sym)
        @has_groupings = true
        @values.each do |v|
          if first_value.nil? && v[1].kind_of?(Array) && (v[1].size > 0)
            first_value = v[1][0][1]
          end
        end

      else

        @values = DILookupCache.l_options(@lookup_name, @parent_id, l[:option_key_type].to_sym, l[:option_value_type].to_sym)        
        @has_groupings = false
        if(@values.size > 0)
          first_value = @values[0][1]
        end

      end
      
    else

      @values = DILookupCache.l_groupoptionsbyparent(@lookup_name, @parent_id, l[:option_key_type].to_sym, l[:option_value_type].to_sym, l[:group_label_type].to_sym)
      @has_groupings = true
      @values.each do |v|
        if first_value.nil? && v[1].kind_of?(Array) && (v[1].size > 0)
          first_value = v[1][0][1]
        end
      end
      
    end

    @blank_text = nil
    @value      = (l[:select_first].to_sym == :true) ? first_value : nil
        
    if((l[:include_blank_if_empty] != "false") && (@values.size == 0))
      @blank_text = l[:include_blank_if_empty] == "true" ? "" : l[:include_blank_if_empty]
    else
      if(@options.has_key?(:include_blank) && @options[:include_blank] != "false")
        @blank_text = @options[:include_blank] == "true" ? "" : @options[:include_blank]
      end
    end

    respond_to do |format|
      format.js
      format.html
    end

  end
 
end 
