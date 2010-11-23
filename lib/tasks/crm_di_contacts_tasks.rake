
namespace :crm do

  namespace :di do

    namespace :contacts do

      desc "Setup DI contact extentions"  
      task :setup => :environment do

        puts "\n" << ("=" * 80) << "\n= Installing DI contact extentions\n" << ("=" * 80)

        if (t = Lookup.find_by_name("contact.type"))
          puts "contact.type lookup exists"
        else
          puts "Creating contact.type lookup"
          t = Lookup.create(:name => "contact.type", :description => "Contact Type", :status => "Active")
          puts "Created contact.type lookup"
        end

        puts "-" * 80

        if (s = t.lookups.find_by_name("contact.type.subtype"))
          puts "contact.type.subtype lookup exists"
        else
          puts "Creating contact.type.subtype lookup"
          s = t.lookups.create(:name => "contact.type.subtype", :description => "Contact Subtype", :status => "Active")
          puts "Created contact.type.subtype lookup"
        end

        puts ("=" * 80) << "\n= Installed DI contact extentions\n" << ("=" * 80) << "\n\n"

      end


      desc "Setup DI contact extentions demonstation data"  
      task :demo => :environment do

        puts "\n" << ("=" * 80) << "\n= Installing DI contact extentions demonstration data\n" << ("=" * 80)

        errors = ""

        if (t = Lookup.find_by_name("contact.type"))
          if !(s = t.lookups.find_by_name("contact.type.subtype"))
            errors << "contact.type.subtype lookup does not exist\n"
          end
        else
          errors << "contact.type lookup does not exist\n"
        end

        errors << (errors.empty? ? "" : "Run 'rake crm:di:contacts:setup to install required lookups")

        if !errors.empty? 
          puts errors
        else

          puts "Required lookups found"

          %w(Client Prospect Supplier Partner).each do |type|

            puts "-" * 80
            code = type.upcase
            desc = "#{type} Description"

            if(ti = t.items.find_by_code(code))
              puts "Contact type '#{type}' exists"
            else
              puts "Creating contact type '#{type}'"
              ti = t.items.new
              ti.code = code
              ti.description = type
              ti.long_description = desc
              ti.assign_next_sequence
              ti.activate
              ti.save
              puts "Created contact type '#{type}'"
            end

            subtypes = case code
              when "CLIENT"   then %w(VIP Premier Regular Blacklist)
              when "PROSPECT" then []
              when "SUPPLIER" then %w(Approved Unapproved)
              when "PARTNER"  then %w(Channel Franchise Brand)
              else []
            end

            subtypes.each do |subtype|

              scode = code + ":" + subtype.upcase
              sdesc = "#{type}/#{subtype} Description"

              if(si = s.items.find_by_code_and_parent_id(scode, ti.id))
                puts "Contact subtype '#{type}/#{subtype}' exists"
              else
                puts "Creating Contact subtype '#{type}/#{subtype}'"
                si = s.items.new
                si.parent_id = ti.id
                si.code = scode
                si.description = subtype
                si.long_description = sdesc
                si.assign_next_sequence
                si.activate
                si.save
                puts "Created Contact subtype '#{type}/#{subtype}'"
              end

            end

          end

        end
 
        puts ("=" * 80) << "\n= " << (errors.empty? ? "Installed" : "Failed to install") << " DI contact extentions demonstration data\n" << ("=" * 80) << "\n\n"

      end


    end
  
  end

end
