require 'openssl'
require 'uri'
require 'base64'
require 'rubygems'
require 'activerecord'

module UrlEncrypt
  def self.cipher
    @@cipher ||= OpenSSL::Cipher::Cipher.new('RC2')
  end
  
  def self.encryptors key, iv=nil
    @@key ||= key
    @@iv ||= (iv || key)
  end
  
  def self.key
    @@key ||= "abcdefghijklmnop"
  end
  
  def self.iv
    @@iv ||= @@key
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def self.extended(base)
      class << base
        self.instance_eval do
          attr_accessor :encryptable_attribute
        end
      end
    end

    def encrypted(options={})
      self.encryptable_attribute = options[:with].to_s if options[:with]
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def self.included(base)
      base.extend ClassMethods
    end
  	
    def _encrypted_attribute
      @_encrypted_attribute ||= self.encrypt(self.send(self.class.encryptable_attribute))
    end

    def _encrypted_attribute= (encrypted_attribute)
      @_encrypted_attribute = encrypted_attribute
    end

    def to_param
      self.class.encryptable_attribute ? self._encrypted_attribute : id.to_s
    end

    def encrypt(attribute_val)
      UrlEncrypt.cipher.encrypt
      UrlEncrypt.cipher.key, UrlEncrypt.cipher.iv = UrlEncrypt.key, UrlEncrypt.iv
      URI.encode((UrlEncrypt.cipher.update(attribute_val.to_s) + UrlEncrypt.cipher.final).unpack("H*").to_s)
    end

    module ClassMethods
      def method_missing(method_id, *args)
        if match = /^find_(all_by|by)_encrypted_([_a-zA-Z]\w*)$/.match(method_id.to_s)          
          finder = determine_finder(match)
          attribute_names = extract_attribute_names_from_match(match)
          super unless all_attributes_exists?(attribute_names)

          self.class_eval %{
            def self.#{method_id}(*args)
              encrypted_str = args[0]
              raise(ActiveRecord::RecordNotFound) if encrypted_str.nil?
              decrypted_str = decrypt(encrypted_str)              
              
              args[0] = decrypted_str

              options = args.extract_options!
              attributes = construct_attributes_from_arguments([:#{attribute_names.join(',:')}], args)
              finder_options = { :conditions => attributes }
              validate_find_options(options)
              set_readonly_option!(options)

              if options[:conditions]
                with_scope(:find => finder_options) do
                  ActiveSupport::Deprecation.silence { self.send(:#{finder}, options) }
                end
              else
                ActiveSupport::Deprecation.silence { self.send(:#{finder}, options.merge(finder_options)) }
              end
            end
          }, __FILE__, __LINE__
          self.send(method_id, *args)
        else
          super
        end
      end
      
      protected
        def decrypt(encrypted_str)
          UrlEncrypt.cipher.decrypt
          UrlEncrypt.cipher.key, UrlEncrypt.cipher.iv = UrlEncrypt.key, UrlEncrypt.iv
          UrlEncrypt.cipher.update(URI.decode(encrypted_str).to_a.pack("H*")) + UrlEncrypt.cipher.final
        end
    end
  end
end