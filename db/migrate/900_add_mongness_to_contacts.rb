class AddMongnessToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :mongness, :string
  end

  def self.down
    remove_column :contacts, :mongness
  end
end
