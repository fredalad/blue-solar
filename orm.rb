require 'csv'

module ORM
  class ORM
    def initialize(name)
      @name = name
      @database = []
    end
    def name
      @name
    end
    def database
      @database
    end
    
    def create_table(attributes = {})
      attributes.each do |attr, value|
        if value.downcase != 'text' && value.downcase != 'int' 
          raise "You cannot create this table you attempted to insert type: #{value}. Only text and ints are allowed" 
        end
        if attr.to_s == 'id'
          raise "The id column is created for you. You do not to include it as a parameter"
          end
      end
      array = []
      hash_map = {'id' => 0}
      attributes.each {|attr, value| hash_map[attr.to_s] = value}
      @database[0] = hash_map
    end
    
    def insert_row(attributes = {})
    if @database.size == 0
      raise "You have not created a table. Please create a table then use this method"
      
    end
      attributes.each do |attr, value|
        if !@database[0].has_key?(attr.to_s.downcase.strip)
          raise "This cannot be inserted. #{attr.to_s} does not exist in the table" 
        end
      end

      hash_map = {'id' => @database[-1]['id'] + 1}
      @database[0].each_key do |key|
        if key != 'id'
          hash_map[key] = nil
        end
      end 
      attributes.each do |attr, value|
        if @database[0][attr.to_s] == 'int'
          if !(/\A[-+]?[0-9]+\z/.match(value.to_s))
            raise "This row cannot be inserted. #{value} is not an integer"
          else
            value = value.to_i
          end
        end
        hash_map[attr.to_s] = value
      end
      @database.push(hash_map)
    end

    def insert_csv(file_path)
      if @database.size == 0
        raise "You have not created a table. Please create a table then use this method"
      end
      CSV.foreach(file_path, {:headers => true, :header_converters => :symbol} ) do |row|
        x = {}
        for header, value in row
          x[header] = value
        end
        insert_row(x)
      end
    end
    def find(column_name, value)
      if @database.size == 0
        raise "You have not created a table. Please create a table then use this method"
      end
      found_values = []
      if !@database[0].has_key?(column_name)
        raise "This column: #{column_name} does not exist in the table" 
      end
      @database[1..-1].each do |row|
        if row[column_name] == value
          found_values.push(row)
        end
      end
      return found_values
    end

    def update(column_name, old_value, new_value)
      if @database.size == 0
        raise "You have not created a table. Please create a table then use this method"
      end
      if !@database[0].has_key?(column_name)
        raise "This column: #{column_name} does not exist in the table" 
      end
      rows_to_update = find(column_name, old_value)
      rows_to_update.each {|row| row[column_name] = new_value}
    end

    def delete_rows(column_name, value)
      if @database.size == 0
        raise "You have not created a table. Please create a table then use this method"
      end
      if !@database[0].has_key?(column_name)
        raise "This column: #{column_name} does not exist in the table" 
      end
      rows_to_delete = find(column_name, value)
      @database -= rows_to_delete
    end
  end
end
