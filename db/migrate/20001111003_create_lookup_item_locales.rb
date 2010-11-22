class CreateLookupItemLocales < ActiveRecord::Migration
  def self.up
    create_table   :lookup_item_locales do |t|
      t.integer    :lookup_item_id,   :null => false, :default => nil
      t.string     :language,         :null => false, :default => 'en-US',       :limit => 10
      t.string     :description,      :null => false, :default => '',            :limit => 255
      t.string     :long_description, :null => false, :default => '',            :limit => 255
      t.datetime   :deleted_at
      t.timestamps
    end

    add_index :lookup_item_locales, [:lookup_item_id, :language, :deleted_at], :unique => true, :name => 'ixu_lookup_item_locales_lookup_item_language'    
    
  end

  def self.down
    drop_table :lookup_item_locales
  end
end
