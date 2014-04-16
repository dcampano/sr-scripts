module SrScripts
  class HostsManager
    def generate_file(file_name)
      sdb = SrScripts::SimpleDB.get

      rows = sdb.select("SELECT * FROM dns_info").body["Items"]

      if rows.length > 0
        File.open(file_name, 'w') { |f|
          f.puts "# THIS FILE MANAGED BY sr-update-hosts SCRIPT"
          f.puts "127.0.0.1 localhost localhost.localdomain"
          rows.each_pair { |item_name, values|
            f.puts "#{values['ip_address'].first} #{item_name}"
          }
        }
      end
    end

    def update_dns(host_name, ip_address)
      sdb = SrScripts::SimpleDB.get
      domain = "dns_info"

      if /^(\d{1,3}\.){3}\d{1,3}$/.match(ip_address) == nil
        p "Usage: sr-update-dns hostname ip_address"
        exit
      end

      sdb.put_attributes(domain, host_name, { "ip_address" => ip_address }, { :replace => "ip_address" })

    end
  end
end
