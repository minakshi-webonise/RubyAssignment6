#!/usr/bin/ruby
require 'active_support/inflector'
require 'csv'
=begin
 class for generating class dyanamically when csv file is given as input
 treating each row as object
=end
class GenerateClassAttribute
  #method for generating class when
  def generate_class(csv_file="profiles.csv")
    puts "enter csv file"
    #csv_file = gets.chomp
    rx = /\A(?<name>.*)\.(?<ext>.*)\z/
    file_name = csv_file.match(rx)[1]
    file_ext = csv_file.match(rx)[2]
    @klass = Object.const_set(file_name.capitalize.singularize, Class.new)
    puts @klass
    puts csv_file
    data = CSV.read(csv_file, :headers => true)
    p data.headers
    header = data.headers
    @klass.class_eval do
      attr_accessor *header
      define_method(:initialize) do |*values|
        header.each_with_index do |name, i|
          instance_variable_set("@"+name, values[i])
        end
      end
    end
  end

  def create_object(csv_file)
    #puts @klass
    #CSV.foreach(csv_file, :headers=>false) do |row|
     # p row
     # puts @klass.new(*row)
     $objects = []
     csv_content = CSV.read(csv_file)

     csv_content.shift
       p csv_content
       arr = csv_content.size
       p arr
    CSV.foreach(csv_file, :headers=>false) do |row|
      #p row
      puts @klass.new(*row).inspect
      $objects << @klass.new(*row)
    end
    $objects
  end
end