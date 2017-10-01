require "csv_petsonic/version"
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'csv'

class Get_csv

  def self.parsing(url,file)
    parse = Get.new(url)
    parse.parsing(url,file)
  end

  class Get_csv::Get

    def initialize(url)
      @url = url
		end

def parsing(url,file)

	CSV.open(file, "a") do |csv|
		csv << ["Name and weight", "Cost", "jpg_url"]
	end
	i = 1
	page = Nokogiri::HTML(open(@url))
	page.xpath('//ul[@class="pagination pull-left"]/li[6]/a/span/text()').each {|a| @number_all_pages = a.content}  
	while i != @number_all_pages.to_i
		new_url = @url + '?p=' + i.to_s
		next_page = Nokogiri::HTML(open(new_url))
		@href_array = get_all_link_pages(next_page)
		@components_to_csv = parse_pages(@href_array,file)
		i+=1
	end

end

def get_all_link_pages(next_page)
	@href_array = []
	@href_array.clear
	next_page.xpath('//div[@class="view col-xs-4"]//a/@href').each do |link|
  		@href_array << link.content
	end
	return @href_array
end

def parse_pages(href_array,file)
	array_length = @href_array.size
	while array_length != 0
		@href_array.each do |x|
			html = Nokogiri::HTML(open(x))
			parse_one_page(html,file)
			array_length -= 1
		end
	end
end

def parse_one_page(html,file)

	CSV.open(file, "a") do |csv|
				
		html.xpath('//div[@class="product-name"]/h1/text()[2]').each {|name| @name = name.content.strip}
		html.xpath('//span[@class="attribute_name"]/text()').each {|a| (@weight = []) << a.content}	
		html.xpath('//span[@class="attribute_price"]/text()').each {|a| (@cost = []) << a.content.strip}	
		html.xpath('//img[@id="bigpic"]/@src').each {|x| (@img = []) << x.content}	

		for i in @weight
			(name_and_weight = []) << @name + ' ' + i
		end

		for a in name_and_weight
			for b in @cost 
				for c in @img
					csv << [a, b, c]
				end
			end
		end
	end
end
end
end
