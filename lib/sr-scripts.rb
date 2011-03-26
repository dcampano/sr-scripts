require 'yaml'

module SrScripts
	class Compute 
		def self.get 
			yml = YAML.load_file '/etc/sr-scripts.yml'	
			@aws_access_key = yml["aws_access_key"]
			@aws_secret_key = yml["aws_secret_key"]	
			return Fog::Compute.new(:provider => "AWS", :aws_access_key_id => @aws_access_key, :aws_secret_access_key => @aws_secret_key, :region => "us-west-1")
		end
	end
	class SimpleDB
		def self.get
			yml = YAML.load_file '/etc/sr-scripts.yml'	
			@aws_access_key = yml["aws_access_key"]
			@aws_secret_key = yml["aws_secret_key"]	
			return Fog::AWS::SimpleDB.new(:aws_access_key_id => @aws_access_key, :aws_secret_access_key => @aws_secret_key)
		end
	end
end
