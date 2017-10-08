require "csv_petsonic/version"
require 'open-uri'
require 'nokogiri'
require 'csv'

class Get_csv

  def self.parsing(url,file)
  parse = Get.new(url,file)
    parse.parsing(url,file)
  end
end

  require 'csv_petsonic/get'