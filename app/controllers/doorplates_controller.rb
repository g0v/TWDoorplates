require 'uri'
require 'net/http'
require 'json'
require 'number_to_cn'

class DoorplatesController < ApplicationController
  def search
    @cityCode = params[:cityCode]
    @areaCodes = params[:areaCode]
    @village = params[:village]
    @neighbor = halfToFull params[:neighbor]
    @street = params[:street]
    @section = parseSection params[:section].to_i
    @lane = halfToFull params[:lane]
    @alley = halfToFull params[:alley]
    @number = halfToFull params[:number]
    @number1 = halfToFull params[:number1]
    @floor = parseFloor params[:floor].to_i
    @ext = halfToFull params[:ext]
    @rows = params[:rows] || 20
    @page = params[:page] || 1
    @results = []
    
    @areaCodes.split(",").each{|areaCode| @results << query({:cityCode => @cityCode, :areaCode => areaCode, :village => @village, :neighbor => @neighbor, :street => @street, :section => @section, :lane => @lane, :alley => @alley, :number => @number, :number1 => @number1, :floor => @floor, :ext => @ext, :rows => @rows, :page => @page})}
    
    respond_to do |format|
      #format.html # search.html.erb
      format.json { render json: mergeResults(@results) }
    end
  end
  
  private
  
  def query(queryParams)
    uri = URI("http://www.ris.gov.tw/doorplateX/doorplateQuery")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = false
    
    timeOffset = 1419431692844
    
    @cityCode = queryParams[:cityCode]
    @areaCode = queryParams[:areaCode]
    queryParams[:areaCode] = @cityCode[0, 5] + @areaCode[1, 3] unless @cityCode.nil? || @cityCode.empty? || @areaCode.nil? || @areaCode.empty?
    
    defaultParams = {:searchType => :doorplate, :datagrid_search_status_2 => :true, :getDoorplateByDoorplate => nil, :tkt => (Time.now.to_f*1000).to_i-timeOffset, :tks => 1}

    body = URI.encode_www_form(defaultParams.merge(queryParams))
    
    #logger.debug body
    
    response = https.post(uri.path, body)
    @result = JSON.parse(response.body)
  end
  
  def mergeResults(results)
    result = {}
    result["rows"] = []
    results.each{|x| result["rows"].concat x["rows"]}
    
    result
  end
  
  def halfToFull(halfString)
    @fullMap = ["０", "１", "２", "３", "４", "５", "６", "７", "８", "９"]
    unless halfString.nil? || (halfString =~ /^\d*$/) == nil || halfString.to_i < 1
      halfString.chars.map{|x| @fullMap[x.to_i]}.inject(:+)
    end
  end
  
  def parseSection(section)
    unless section < 1
      section.to_cn_words
    end
  end
  
  def parseFloor(floor)
    unless floor < 2
      floor.to_cn_words
    end
  end
end
