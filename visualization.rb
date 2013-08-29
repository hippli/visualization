require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'erb'

File.open('gdp.txt', 'w') do |f|
  page = Nokogiri::HTML(open("http://data.worldbank.org/indicator/NY.GDP.MKTP.CD"))
  row = page.css('tr')

  @gdp_hash = {}

  row.each do |countries|
    gdp = countries.css('td.views-field.views-field-wbapi-data-value-2012.wbapi-data-value.wbapi-data-value-last').text.strip
    country = countries.css('td.views-field.views-field-country-value').text.strip
    @gdp_hash[country] = gdp
  end

  @gdp_hash.each do |key, value|
    f.write("<div>" + key + " " + value + "</div>\n")
  end

  template = ERB.new(File.read('visualization.erb')).result
  
  File.open('visualization.html', 'w') do |x|
    x.write(template)
  end

end