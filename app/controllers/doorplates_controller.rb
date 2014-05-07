require 'uri'
require 'net/http'
require 'json'

class DoorplatesController < ApplicationController
  def search
    uri = URI("http://www.ris.gov.tw/swpro/doorplate.do?getDoorplateByDoorplate")
    
    @cityCode = params[:cityCode]
    @areaCode = params[:areaCode]
    @village = params[:village]
    @neighbor = params[:neighbor]
    @street = params[:street]
    @section = params[:section]
    @lane = params[:lane]
    @alley = params[:alley]
    @number = params[:number]
    @number1 = params[:number1]
    @floor = params[:floor]
    @ext = params[:ext]
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
end
