class Lookup < ActiveRecord::Base

  # Attributes accessible from outside the model
  attr_accessible :name, :description, :parent_id, :lookup_type, :status

  # Relationships
  has_many :lookups,   :foreign_key => 'parent_id',
                       :class_name  => 'Lookup',
                       :dependent   => :destroy

  # Standard Plugins
  acts_as_paranoid

  # Default behaviour
  default_scope :order      => 'name ASC'
  default_scope :conditions => { :deleted_at => nil }
  
  # Named scopes
  named_scope :root_lookups, :conditions => { :parent_id => nil }

  # Validations
  validates_presence_of   :name, :lookup_type, :status

  validates_uniqueness_of :name, :case_sensitive => false

  validates_length_of     :name,        :maximum => 100
  validates_length_of     :description, :maximum => 255, :allow_blank => true
  validates_length_of     :lookup_type, :maximum => 50
  validates_length_of     :status,      :maximum => 50

  # Event callbacks
  #after_initialize :default_values
  
  def parent
    self.class.find_by_id(self.parent_id) unless self.parent_id.nil?
  end
  
  def inactive?
    self.status == "Inactive"
  end
  
  def unpublished?
    self.status == "Unpublished"
  end  
  
  def active?
    self.status == "Active"
  end

  def activate
    self.status = "Active"
  end
  
  def activate!
    self.update_attribute(:status, "Active")
  end
  
  def unpublish
    self.status = "Unpublished"
  end

  def unpublish!
    self.update_attribute(:status, "Unpublished")
  end
  
  def inactivate
    self.status = "Inactive"
  end
  
  def inactivate!
    self.update_attribute(:status, "Inactive")
  end
  
#  def deleted?
    # Stub out the acts_as_paranoid behaviour for now
#    true
#  end
  
  
  private
  
  #def after_initialize
  #  self.lookup_type ||= 'Standard'
  #  self.status      ||= 'Active'    
  #end
  
end
