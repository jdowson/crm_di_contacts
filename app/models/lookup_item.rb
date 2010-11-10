# Schema
#
#      t.integer    :lookup_id,        :null => false, :default => nil
#      t.integer    :sequence,         :null => false, :default => nil
#      t.integer    :parent_id,        :null => true,  :default => nil
#      t.string     :code,             :null => false, :default => nil,           :limit => 50
#      t.string     :unique_code,      :null => false, :default => nil,           :limit => 70
#      t.string     :language,         :null => false, :default => 'en-US',       :limit => 10
#      t.string     :description,      :null => false, :default => '',            :limit => 255
#      t.string     :long_description, :null => false, :default => '',            :limit => 255
#      t.string     :html_color,       :null => false, :default => '',            :limit => 50
#      t.string     :item_type,        :null => false, :default => 'Standard',    :limit => 50
#      t.string     :status,           :null => false, :default => 'Unpublished', :limit => 50
#      t.datetime   :deleted_at
#      t.timestamps


class LookupItem < ActiveRecord::Base

  # Attributes accessible from outside the model
  attr_accessible       :lookup_id, :sequence, :parent_id, :code, :language, 
                        :description, :long_description, :html_color, :item_type, :status

  # Model Callbacks
  before_destroy       :check_if_has_children
  before_create        :set_defaults_create
  
  # Relationships
  has_many   :items,   :foreign_key => 'parent_id',
                       :class_name  => 'LookupItem'
                       # ,:dependent   => :destroy
  
  has_many   :locales, :foreign_key => 'lookup_item_id',
                       :class_name  => 'LookupItemLocale'
                       # ,:dependent   => :destroy
  
  belongs_to :lookup

  # Standard Plugins
  acts_as_paranoid

  # Default behaviour
  default_scope   :order      => 'sequence ASC'
  
  simple_column_search :code, :description, :long_description, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }

  # Validations
  validates_presence_of   :code, :language, :status

  validates_uniqueness_of :code, :case_sensitive => false, :scope => [:lookup_id, :parent_id]

  validates_length_of     :code,             :maximum => 50
  validates_length_of     :description,      :maximum => 255, :allow_blank => true
  validates_length_of     :long_description, :maximum => 255, :allow_blank => true
  validates_length_of     :html_color,       :maximum => 50,  :allow_blank => true

  # Provide seq accessor to fix Factory Girl
  #----------------------------------------------------------------------------
  def seq=(i)
    write_attribute(:sequence, i)
  end

  # Override lookup_id accessor to set unique_code
  #----------------------------------------------------------------------------
  def lookup_id=(i)
    write_attribute(:lookup_id, i)
    set_unique_code
  end

  # Override parent_id accessor to set unique_code
  #----------------------------------------------------------------------------
  def parent_id=(i)
    write_attribute(:parent_id, i)
    set_unique_code
  end

  # Override code accessor to set unique_code
  #----------------------------------------------------------------------------
  def code=(s)
    write_attribute(:code, s)
    set_unique_code
  end

  # Set unique_code
  #----------------------------------------------------------------------------
  def set_unique_code
    lid = nilz(self.lookup_id)
    pid = nilz(self.parent_id)
    code = self.code.nil? ? "" : self.code
    write_attribute(:unique_code, lid.to_s << ":" << pid.to_s << ":" << code)
  end

  # Get the parent lookup of a child lookup
  #----------------------------------------------------------------------------
  def parent
    self.class.find_by_id(self.parent_id) unless self.parent_id.nil?
  end
  
  # Is the lookupItem active?
  #----------------------------------------------------------------------------
  def active?
    self.status == "Active"
  end

  # Set a lookupItem to be active
  #----------------------------------------------------------------------------
  def activate
    self.status = "Active"
  end
  
  # Activate a lookupItem immediately
  #----------------------------------------------------------------------------
  def activate!
    self.update_attribute(:status, "Active")
  end
  
  # Is the lookupItem unpublished?
  #----------------------------------------------------------------------------
  def unpublished?
    self.status == "Unpublished"
  end  
  
  # Set a lookupItem to be unpublished
  #----------------------------------------------------------------------------
  def unpublish
    self.status = "Unpublished"
  end

  # Unpublish a lookupItem immediately
  #----------------------------------------------------------------------------
  def unpublish!
    self.update_attribute(:status, "Unpublished")
  end
    
  # Is the lookupItem inactive?
  #----------------------------------------------------------------------------
  def inactive?
    self.status == "Inactive"
  end
  
  # Set the lookupItem to be inactive
  #----------------------------------------------------------------------------
  def inactivate
    self.status = "Inactive"
  end
  
  # Inactivate a lookupItem immediately
  #----------------------------------------------------------------------------
  def inactivate!
    self.update_attribute(:status, "Inactive")
  end

  # Get sibling lookup items (same lookup, same parent, sequence sorted
  #----------------------------------------------------------------------------
  def siblings
    LookupItem.find_all_by_lookup_id_and_parent_id(self.lookup_id, self.parent_id).sort! { |a,b| a.sequence <=> b.sequence }
  end
  
  # Assign new item next sequence among siblings
  #----------------------------------------------------------------------------
  def assign_next_sequence

    s = siblings
    
    self.sequence = s.empty? ? 1 : (s.last.sequence + 1)
  
  end
  
  # Move item up amongst its siblings
  #----------------------------------------------------------------------------
  def move_up!
    
    cur  = self.sequence

    swap = LookupItem.find_by_lookup_id_and_parent_id_and_sequence(self.lookup_id, self.parent_id, self.sequence - 1)
    
    self.update_attribute(:sequence, cur - 1)
    swap.update_attribute(:sequence, cur)  
    
  end
  
  # Move item down amongst its siblings
  #----------------------------------------------------------------------------
  def move_down!

    cur  = self.sequence

    swap = LookupItem.find_by_lookup_id_and_parent_id_and_sequence(self.lookup_id, self.parent_id, self.sequence + 1)
    
    self.update_attribute(:sequence, cur + 1)
    swap.update_attribute(:sequence, cur)  
    
  end


  # Is this the last sibling?
  #----------------------------------------------------------------------------
  def last_sibling?
    self.sequence == siblings.last.sequence
  end



  private
  
  # Prevent deleting a lookup if it has child lookups
  #----------------------------------------------------------------------------
  def check_if_has_children
    self.items.count == 0
  end
  
  # Set new record defaults
  #----------------------------------------------------------------------------
  def set_defaults_create
     self.language = I18n.default_locale.to_s
  end
  
end
