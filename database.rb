#!/usr/bin/ruby
require "rubygems"
require 'active_support/inflector'
require 'csv'

require "mysql"

class DatabaseOpetaion
 def generate_class(csv_file="profiles.csv")
    rx = /\A(?<name>.*)\.(?<ext>.*)\z/
    file_name = csv_file.match(rx)[1]
    file_ext = csv_file.match(rx)[2]
    @klass = Object.const_set(file_name.capitalize.singularize, Class.new)
    puts @klass
    puts csv_file
    data = CSV.read(csv_file, :headers => true)
    p data.headers
    header = data.headers
    @h = header
    @klass.class_eval do
      attr_accessor *header
      define_method(:initialize) do |*values|
        header.each_with_index do |name, i|
          instance_variable_set("@"+name, values[i])
        end
      end
    end
  end

  def create_object(csv_file="profiles.csv")
     @objects = []
     csv_content = CSV.read(csv_file)

     csv_content.shift
       p csv_content
       arr = csv_content.size
       p arr
    CSV.foreach(csv_file, :headers=>false) do |row|
      puts @klass.new(*row).inspect
      @objects << @klass.new(*row)
    end
    @objects
  end

  def database_connection
    con = Mysql.new 'localhost', 'root', 'webonise6186' , 'db'

    puts "in connection"
    p @h
    table_name = @klass.to_s.downcase.pluralize
    puts table_name
    con.query("CREATE TABLE IF NOT EXISTS #{table_name} (Id INT PRIMARY KEY AUTO_INCREMENT)")
    @h.each do |arg|
      con.query("ALTER TABLE #{table_name} ADD #{arg.to_s.downcase} VARCHAR(20)")
    end
    puts @objects.last.Age
    puts @objects.size
    for i in 0...@objects.size
      puts @objects[i].Age
       con.query("INSERT INTO #{table_name}(firstname,lastname, age, gender) VALUES('#{@objects[i].Firstname}','#{@objects[i].Lastname}', #{@objects[i].Age.to_s}, '#{@objects[i].Gender}')")
    end



  end
end
obj = DatabaseOpetaion.new
obj.generate_class
obj.create_object
obj.database_connection
