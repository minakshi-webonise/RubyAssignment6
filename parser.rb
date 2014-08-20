=begin
Class for parsing html file and converting data of html file to csv
=end
require 'csv'
class ParseFile
  @@filename = "profiles.html"

  def file_read

    File.open(@@filename,"r") do |file|
      file.each_line do |line|
        rg =/<th.*>([\w\s\.*]*)<\/th>/i
        s = line.scan(rg)
        arr = s.to_a
        if arr.any?
          @temp_arr ||= Array.new
          arr.each{|i| @temp_arr.push(arr) }
          @temp_arr
        end
      end
      @temp_arr =  @temp_arr.flatten
      CSV.open("file.csv", "w") do |header|
        if header.tell == 0
          header << @temp_arr
        end
      end

  end
  end

  #method for putting data to csv in ruby
  def file_write
    File.open(@@filename,"r") do |file|
      file.each_line do |line|
        rg = /<td.*>([\w\s\.*]*)<\/td>/i
        str = line.scan(rg)

        arr = str.to_a
        if arr.any?
          @temp_arr ||= []
          arr.each{|i| @temp_arr.push(arr) }
          @temp_arr
        end

      end
      @temp_arr =  @temp_arr.flatten
      p @temp_arr
      CSV.open("profiles.csv", "w") do |row|
        @temp_arr.each_slice(4).to_a.each do |temp|
          row << temp
        end
      end

    end
  end




end
parse = ParseFile.new
parse.file_read
parse.file_write
