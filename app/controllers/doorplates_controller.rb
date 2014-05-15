require 'uri'
require 'net/http'
require 'json'
require 'number_to_cn'

class DoorplatesController < ApplicationController
  def search
    uri = URI("http://www.ris.gov.tw/swpro/doorplate.do?getDoorplateByDoorplate")
    
    @cityCode = params[:cityCode]
    @areaCode = params[:areaCode]
    @village = params[:village]
    @neighbor = halfToFull params[:neighbor]
    @street = params[:street]
    @section = halfToFull params[:section]
    @lane = halfToFull params[:lane]
    @alley = halfToFull params[:alley]
    @number = halfToFull params[:number]
    @number1 = halfToFull params[:number1]
    @floor = parseFloor params[:floor].to_i
    @ext = halfToFull params[:ext]
    @tk = (Time.now.to_f*1000).to_i
    @tks = 0
    unless @cityCode.nil? && @areaCode.nil?
      @adminCode = @cityCode[0, 5] + @areaCode[1, 3]
    end
    
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = false

    body = URI.encode_www_form({:getDoorplateByDoorplate => nil, :adminCode => @adminCode, :cityCode => @cityCode, :areaCode => @areaCode, :village => @village, :neighbor => @neighbor, :street => @street, :section => @section, :lane => @lane, :alley => @alley, :number => @number, :number1 => @number1, :floor => @floor, :ext => @ext, :tk => @tk, :tks => @tks})

    response = https.post(uri.path, body)
    @result = JSON.parse(response.body)
    
    respond_to do |format|
      #format.html # search.html.erb
      format.json { render json: @result }
    end
  end
  
  private
  def halfToFull(halfString)
    @fullMap = ["０", "１", "２", "３", "４", "５", "６", "７", "８", "９"]
    unless halfString.nil? || (halfString =~ /^\d*$/) == nil || halfString.to_i < 1
      halfString.chars.map{|x| @fullMap[x.to_i]}.inject(:+)
    end
  end
  
  def parseFloor(floor)
    unless floor < 2
      floor.to_cn_words
    end
  end
end
