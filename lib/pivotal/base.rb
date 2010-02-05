require 'rubygems'
require 'rest_client'
require 'nokogiri'
require 'builder'

module Pivotal
  class Base
    include Pivotal::Associations
    
    attr_accessor :resource, :xml
    undef id
    
    def initialize(params = {})
      params.each do |key, value|
        send("#{key}=", value)
      end
    end    
    
    def xml
      @xml ||= resource.get
    end

    def parsed_resource
      @parsed_resource ||= Nokogiri::XML(xml)
    end
    
    def method_missing(method, *args)
      parsed_resource.xpath("*/" + method.to_s).text
    end
    
    def update_attributes(options = {})
      @xml = resource.put generate_xml(options)
      return self
    end
    
    class << self
      def name_as_xml_attribute
        self.name.gsub(/.+\:\:/, '').downcase
      end
      
      def xpath
        '//' + self.name_as_xml_attribute
      end
    end
    
  private
  
    def generate_xml(options = {})
      builder = Builder::XmlMarkup.new
      builder.__send__ self.class.name_as_xml_attribute do
        allowed_keys(options).each do |key, value|
          builder.__send__(key, value.to_s)
        end
      end
      
      builder.target!
    end
    
    def allowed_keys(options = {})
      options.reject do |key, _|
        !%w[id story_type url estimate current_state
           description name requested_by owned_by
           created_at accepted_at labels].include? key.to_s
      end
    end
    
  end
end