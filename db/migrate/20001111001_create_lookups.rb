class CreateLookups < ActiveRecord::Migration
  def self.up
    create_table :lookups do |t|
      t.string  :name,        :null => false, :default => nil,           :limit => 100
      t.integer :parent_id,   :null => true,  :default => nil
      t.string  :description, :null => true,  :default => '',            :limit => 255
      t.string  :status,      :null => false, :default => 'Unpublished', :limit => 50
      t.string  :lookup_type, :null => false, :default => 'Standard',    :limit => 50

      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :lookups
  end
end
