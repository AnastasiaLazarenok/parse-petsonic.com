class Get_csv::Get
    
  def initialize(url,file)
    @url = url
    @file = file
  end
    
  def parsing(url,file)
    CSV.open(file, "w") do |csv|
      csv << ["Name and weight", "Cost", "jpg_url"]
      page = Nokogiri::HTML(open(url))
      number_all_pages = page.xpath('//ul[@class="pagination pull-left"]/li[6]/a/span/text()')[0].content.to_i
      for i in 1..number_all_pages
        p i
        new_url = url + '?p=' + i.to_s
        next_page = Nokogiri::HTML(open(new_url))
        href_array = get_all_link_pages(next_page)
        parse_pages(href_array,csv)
      end 
    end
  end

  def get_all_link_pages(next_page)
    href_array = []
    next_page.xpath('//div[@class="view col-xs-4"]//a/@href').each {|link| href_array << link.content}  
    return href_array
  end

  def parse_pages(href_array,csv)
    href_array.each do |x|
      html = Nokogiri::HTML(open(x))
      parse_one_page(html,csv)
    end
  end

  def parse_one_page(html,csv)
    weight = []
    cost = []   
    name1 = html.xpath('//div[@class="product-name"]/h1/text()[2]')[0].content.strip
    html.xpath('//span[@class="attribute_name"]/text()').each {|a| weight << a.content} 
    html.xpath('//span[@class="attribute_price"]/text()').each {|a| cost << a.content.strip}  
    img = html.xpath('//img[@id="bigpic"]/@src')[0].content
    
    for i in 0..weight.size-1
      csv << [name1 + ' ' + weight[i],cost[i],img]
    end
  end
end
    