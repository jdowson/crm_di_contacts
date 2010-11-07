class CreateLookupItems < ActiveRecord::Migration
  def self.up
    create_table   :lookup_items do |t|
      t.integer    :lookup_id,        :null => false, :default => nil
      t.integer    :sequence,         :null => false, :default => nil
      t.integer    :parent_id,        :null => true,  :default => nil
      t.string     :code,             :null => false, :default => nil,           :limit => 50
      t.string     :unique_code,      :null => false, :default => nil,           :limit => 70
      t.string     :language,         :null => false, :default => 'en-US',       :limit => 10
      t.string     :description,      :null => false, :default => '',            :limit => 255
      t.string     :long_description, :null => false, :default => '',            :limit => 255
      t.string     :html_color,       :null => false, :default => '',            :limit => 50
      t.string     :item_type,        :null => false, :default => 'Standard',    :limit => 50
      t.string     :status,           :null => false, :default => 'Unpublished', :limit => 50
      t.datetime   :deleted_at
      t.timestamps
    end

    add_index :lookup_items, [:lookup_id, :parent_id], :unique => false, :name => 'ixu_lookup_items_lookup_parent'    
    add_index :lookup_items, [:lookup_id, :parent_id, :code], :unique => true, :name => 'ixu_lookup_items_lookup_parent_code'    
    add_index :lookup_items, :unique_code, :unique => true, :name => 'ixu_lookup_items_unique_code'
    
  end

  def self.down
    drop_table :lookup_items
  end
end
