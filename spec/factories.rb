# Use Factory Girl to create symbols to simulate the core models.
Factory.define :lookup do |lookup|
  lookup.name                   "account.type"
  lookup.description            "Account Type"
  lookup.parent_id              nil
  lookup.status                 "Active"
  lookup.lookup_type            "Standard"
  lookup.deleted_at             nil
end
