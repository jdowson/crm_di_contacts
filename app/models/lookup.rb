class Lookup < ActiveRecord::Base

  # Attributes accessible from outside the model
  attr_accessible    :name, :description, :parent_id, :lookup_type, :status

  # Model Callbacks
  before_destroy     :check_if_has_children

  # Relationships
  has_many :lookups, :foreign_key => 'parent_id',
                     :class_name  => 'Lookup'
                     # ,:dependent   => :destroy

  has_many :items,   :class_name  => 'LookupItem',
                     :dependent   => :destroy

  # Standard Plugins
  acts_as_paranoid

  # Default behaviour
  default_scope   :order      => 'name ASC'
  
  simple_column_search :name, :description, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }

  # Validations
  validates_presence_of   :name, :lookup_type, :status

  validates_uniqueness_of :name, :case_sensitive => false

  validates_length_of     :name,        :maximum => 100
  validates_length_of     :description, :maximum => 255, :allow_blank => true
  validates_length_of     :lookup_type, :maximum => 50
  validates_length_of     :status,      :maximum => 50

  
  # Named scopes

  # Child lookups of the lookup
  #----------------------------------------------------------------------------
  named_scope :root_lookups, :conditions => { :parent_id => nil }


  # Get the parent lookup of a child lookup
  #----------------------------------------------------------------------------
  def parent
    self.class.find_by_id(self.parent_id) unless self.parent_id.nil?
  end
  
  # Get the items for a particular parent lookup item
  #----------------------------------------------------------------------------
  def items_for_parent(parent_id)
    items.find_all_by_parent_id(parent_id).sort! { |a,b| a.sequence <=> b.sequence }
  end
  
  # Is the lookup active?
  #----------------------------------------------------------------------------
  def active?
    self.status == "Active"
  end

  # Set a lookup to be active
  #----------------------------------------------------------------------------
  def activate
    self.status = "Active"
  end
  
  # Activate a lookup immediately
  #----------------------------------------------------------------------------
  def activate!
    self.update_attribute(:status, "Active")
  end
  
  # Is the lookup unpublished?
  #----------------------------------------------------------------------------
  def unpublished?
    self.status == "Unpublished"
  end  
  
  # Set a lookup to be unpublished
  #----------------------------------------------------------------------------
  def unpublish
    self.status = "Unpublished"
  end

  # Unpublish a lookup immediately
  #----------------------------------------------------------------------------
  def unpublish!
    self.update_attribute(:status, "Unpublished")
  end
    
  # Is the lookup inactive?
  #----------------------------------------------------------------------------
  def inactive?
    self.status == "Inactive"
  end
  
  # Set the lookup to be inactive
  #----------------------------------------------------------------------------
  def inactivate
    self.status = "Inactive"
  end
  
  # Inactivate a lookup immediately
  #----------------------------------------------------------------------------
  def inactivate!
    self.update_attribute(:status, "Inactive")
  end
  

  private
  

  # Prevent deleting a lookup if it has child lookups
  #----------------------------------------------------------------------------
  def check_if_has_children
    self.lookups.count == 0
  end
  
  
end
