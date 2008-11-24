require 'url_encrypt'
require 'activerecord'

ActiveRecord::Base.send(:include, UrlEncrypt)