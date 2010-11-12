
# Migrate extension
namespace :db do
  namespace :migrate do
    description = "Migrate the database through scripts in vendor/plugins/di_core/db/migrate"
    description << "and update db/schema.rb by invoking db:schema:dump."
    description << "Target specific version with VERSION=x. Turn off output with VERBOSE=false."

    desc description
    task :di_core => :environment do
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate("vendor/plugins/crm_di_core/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end
  end
end

# Update public assets
namespace :crm do
  namespace :di_core do  
    desc "Setup di_core plugin, installing public assets"  
    task :setup do
      #system "rsync -ruv vendor/plugins/crm_di_core/db/migrate db"  
      system "rsync -ruv vendor/plugins/crm_di_core/public ."  
    end  
  end
end
