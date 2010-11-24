class AddTypeSubTypeToContacts < ActiveRecord::Migration
  def self.up

    add_column :contacts, :contact_type_id,     :integer, { :null => true, :default => nil }
    add_column :contacts, :contact_sub_type_id, :integer, { :null => true, :default => nil }

    add_index  :contacts, [:contact_type_id, :contact_sub_type_id], :unique => false, :name => 'ix_contacts_type_id_sub_type_id'    

  end

  def self.down
    remove_index  :contacts, :ix_contacts_type_id_sub_type_id
    remove_column :contacts, :contact_type_id
    remove_column :contacts, :contact_subtype_id
  end
end
