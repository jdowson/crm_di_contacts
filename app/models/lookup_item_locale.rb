# Schema
#
#      t.integer    :lookup_item_id,   :null => false, :default => nil
#      t.string     :language,         :null => false, :default => 'en-US',       :limit => 10
#      t.string     :description,      :null => false, :default => '',            :limit => 255
#      t.string     :long_description, :null => false, :default => '',            :limit => 255
#      t.datetime   :deleted_at
#      t.timestamps


class LookupItemLocale < ActiveRecord::Base

  # Attributes accessible from outside the model
  attr_accessible    :lookup_item_id, :language, :description, :long_description

  # Model Callbacks
  
  # Relationships
  belongs_to :lookup_item

  # Standard Plugins
  acts_as_paranoid

  # Default behaviour
  default_scope   :order      => 'language ASC'
  
  # Validations
  validates_presence_of   :language

  validates_uniqueness_of :language, :case_sensitive => false, :scope => [:lookup_item_id]

  validates_length_of     :description,      :maximum => 255, :allow_blank => true
  validates_length_of     :long_description, :maximum => 255, :allow_blank => true

  private
  
end
 
