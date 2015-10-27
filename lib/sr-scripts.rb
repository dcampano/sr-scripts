require 'yaml'
require 'logger'
require 'fog'

require 'sr-scripts/HostsManager'

module SrScripts
  class ConfigFile
    def self.get
      if File.exists? '.sr-scripts.yml'
        return YAML.load_file '.sr-scripts.yml'
      elsif ENV["HOME"] && File.exists?(File.expand_path('~/.sr-scripts.yml'))
        return YAML.load_file File.expand_path('~/.sr-scripts.yml')
      elsif File.exists? '/etc/sr-scripts.yml'
        return YAML.load_file '/etc/sr-scripts.yml'
      else
        puts "Config File Is Missing: searching for ./.sr-scripts.yml, ~/.sr-scripts.yml or /etc/sr-scripts.yml"
        exit 1
      end
    end
  end
	class Compute 
		def self.get region=nil
      @region = region || 'us-west-1'
      yml = ConfigFile.get
			@aws_access_key = yml["aws_access_key"]
			@aws_secret_key = yml["aws_secret_key"]	
			return Fog::Compute.new(:provider => "AWS", :aws_access_key_id => @aws_access_key, :aws_secret_access_key => @aws_secret_key, :region => @region)
		end
    def self.find_connection(instance_id)
      self.get_regions.each do |region|
        conn = self.get(region)
        server = conn.servers.get(instance_id)
        if server
          return conn
        end
      end
      puts "Couldn't Find Server With Instance Id: #{instance_id}"
    end
    def self.find_instance(instance_id)
      self.get_regions.each do |region|
        conn = self.get(region)
        server = conn.servers.get(instance_id)
        if server
          return server
        end
      end
      puts "Couldn't Find Server With Instance Id: #{instance_id}"
      return nil
    end
    def self.get_regions
      return ['us-west-1', 'us-west-2', 'us-east-1']
    end
	end
	class SimpleDB
		def self.get
      yml = ConfigFile.get
			@aws_access_key = yml["aws_access_key"]
			@aws_secret_key = yml["aws_secret_key"]	
			return Fog::AWS::SimpleDB.new(:aws_access_key_id => @aws_access_key, :aws_secret_access_key => @aws_secret_key, :host => "sdb.amazonaws.com")
		end
	end
	class SES
		def self.get
      yml = ConfigFile.get
			@aws_access_key = yml["aws_access_key"]
			@aws_secret_key = yml["aws_secret_key"]	
			return Fog::AWS::SES.new(:aws_access_key_id => @aws_access_key, :aws_secret_access_key => @aws_secret_key)
		end
	end
	class SNS
		def self.get
      yml = ConfigFile.get
			@aws_access_key = yml["aws_access_key"]
			@aws_secret_key = yml["aws_secret_key"]	
			return Fog::AWS::SNS.new(:aws_access_key_id => @aws_access_key, :aws_secret_access_key => @aws_secret_key, :region => 'us-east-1')
		end
	end
	class Log
		def self.get 
			@log = Logger.new(STDOUT)
			@log.level = Logger::INFO
			@log.formatter = proc { |severity, datetime, progname, msg|
			    d = datetime.strftime("%Y-%m-%d %H:%M:%S")
			    "[#{d}] #{severity}: #{msg}\n"
			}	
			return @log
		end
	end
end
