require 'yaml'
require 'logger'

module SrScripts
  class ConfigFile
    def self.get
      if File.exists? '.sr-scripts.yml'
        return YAML.load_file '.sr-scripts.yml'
      elsif File.exists? '/etc/sr-scripts.yml'
        return YAML.load_file '/etc/sr-scripts.yml'
      else
        puts "Config File Is Missing: searching for ./.sr-scripts.yml or /etc/sr-scripts.yml"
        exit 1
      end
    end
  end
	class Compute 
		def self.get 
      yml = ConfigFile.get
			@aws_access_key = yml["aws_access_key"]
			@aws_secret_key = yml["aws_secret_key"]	
			return Fog::Compute.new(:provider => "AWS", :aws_access_key_id => @aws_access_key, :aws_secret_access_key => @aws_secret_key, :region => "us-west-1")
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
