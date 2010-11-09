
# Use Factory Girl to create symbols to simulate the core models.

# define an incremental username
#Factory.sequence :user do |n|
#  "user#{n}" 
#end

# define a user factory
#Factory.define :user do |u|
#  u.admin      false
#  u.username { Factory.next(:user) } # lazy loaded
#end

# define a project factory with associated user
#Factory.define :project do |p|
#  p.title 'myproject'
#  p.creator   {|a| a.association(:user) } # again lazy loaded
#end

Factory.sequence :seq_num do |n|
  n 
end

Factory.define :lookup do |lookup|
  lookup.name                   "account.type"
  lookup.description            "Account Type"
  lookup.parent_id              nil
  lookup.status                 "Active"
  lookup.lookup_type            "Standard"
  lookup.deleted_at             nil
end

Factory.define :lookup_item do |lookup_item|
  lookup_item.lookup_id         1
  lookup_item.seq              { Factory.next(:seq_num) }
  lookup_item.parent_id         nil
  lookup_item.code              "A0001"
  lookup_item.language          "EN-UK"
  lookup_item.description       "A0001 Description"
  lookup_item.long_description  "Long description for A0001"
  lookup_item.html_color        "lightblue"
  lookup_item.item_type         "Standard"
  lookup_item.status            "Active"
  lookup_item.deleted_at        nil
end