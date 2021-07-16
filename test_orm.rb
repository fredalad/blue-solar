require_relative "orm"
require "test/unit"
 
class TestSimpleNumber < Test::Unit::TestCase
 
  def setup
    @test_db = ORM::ORM.new('test_db')
    @test_db.create_table(column1: 'text', column2: 'int', column3: 'text')
  end

  def test_initialization_with_three_columns
    # @test_db.create_table(column1: 'text', column2: 'int', column3: 'text')
    assert_equal(@test_db.name, 'test_db')
    assert_equal(@test_db.database.size, 1)
    assert_equal(@test_db.database[0]['column1'], 'text')
    assert_equal(@test_db.database[0]['column2'], 'int')
    assert_equal(@test_db.database[0]['column3'], 'text')
  end

  def test_create_table_type_error
    begin
      @test_db.create_table(column1: 'this will fail')
    rescue Exception => ex
      assert_equal(ex.to_s, 'You cannot create this table you attempted to insert type: this will fail. Only text and ints are allowed')
    end
  end

  def test_create_table_id_as_column_error
    begin
      @test_db.create_table(id: 'text')
    rescue Exception => ex
      assert_equal(ex.to_s, 'The id column is created for you. You do not to include it as a parameter')
    end
  end

  def test_insert_row_one_parameter
    @test_db.insert_row(column1: 'test')
    assert_equal(@test_db.database.size, 2)
    assert_equal(@test_db.database[1]['column1'], 'test')
  end

  def test_insert_row_multiple_parameters
    @test_db.insert_row(column1: 'blah', column2: 1, column3: 'test')
    assert_equal(@test_db.database.size, 2)
    assert_equal(@test_db.database[1]['column1'], 'blah')
    assert_equal(@test_db.database[1]['column2'], 1)
    assert_equal(@test_db.database[1]['column3'], 'test')
  end

  def test_insert_invalid_type
    begin
      @test_db.insert_row(column1: 'blah', column2: 'this should be int', column3: 'test')
    rescue Exception => ex
      assert_equal(ex.to_s, 'This row cannot be inserted. this should be int is not an integer')
    end
  end

  def test_insert_row_with_no_table
    no_table = ORM::ORM.new('no table')
    begin
      no_table.insert_row(column1: 'this will fail')
    rescue Exception => ex
      assert_equal(ex.to_s, 'You have not created a table. Please create a table then use this method')
    end
  end
   
  def test_find_empty_result
    @test_db.insert_row(column1: 'blah', column2: 1, column3: 'test')
    found_values =  @test_db.find('column1', 'empty')
    assert_equal(found_values.size, 0)
  end

  def test_find_one_row
    @test_db.insert_row(column1: 'blah', column2: 1, column3: 'test')
    found_values =  @test_db.find('column1', 'blah')
    assert_equal(found_values.size, 1)
    assert_equal(found_values, [{"id"=>1, "column1"=>"blah", "column2"=>1, "column3"=>"test"}])
  end

  def test_find_multiple_rows
    @test_db.insert_row(column1: 'blah', column2: 1, column3: 'test')
    @test_db.insert_row(column1: 'blah', column2: 2, column3: 'test2')
    @test_db.insert_row(column1: 'wont find', column2: 3, column3: 'test3')
    found_values =  @test_db.find('column1', 'blah')
    assert_equal(found_values.size, 2)
    
    assert_equal(found_values, [{"column1"=>"blah", "column2"=>1, "column3"=>"test", "id"=>1},
                                {"column1"=>"blah", "column2"=>2, "column3"=>"test2", "id"=>2}])
  end

  def test_find_with_no_table
    no_table = ORM::ORM.new('no table')
    begin
      no_table.find('column1', 'this will fail')
    rescue Exception => ex
      assert_equal(ex.to_s, 'You have not created a table. Please create a table then use this method')
    end
  end

  def test_find_with_invalid_column
    begin
      @test_db.find('column', 'this will fail')
    rescue Exception => ex
      assert_equal(ex.to_s, 'This column: column does not exist in the table')
    end
  end

  def test_update_single_row
    @test_db.insert_row(column2: 1)
    @test_db.update('column2', 1, 2)
    assert_equal(@test_db.database[1], {"id"=>1, "column1"=>nil, "column2"=>2, "column3"=>nil})
  end

  def test_update_multiple_rows
    @test_db.insert_row(column2: 1)
    @test_db.insert_row(column2: 1)
    @test_db.update('column2', 1, 2)
    assert_equal(@test_db.database[1], {"id"=>1, "column1"=>nil, "column2"=>2, "column3"=>nil})
    assert_equal(@test_db.database[2], {"id"=>2, "column1"=>nil, "column2"=>2, "column3"=>nil})
  end

  def test_update_with_no_table
    no_table = ORM::ORM.new('no table')
    begin
      no_table.update('column1', 'this', 'will fail')
    rescue Exception => ex
      assert_equal(ex.to_s, 'You have not created a table. Please create a table then use this method')
    end
  end

  def test_update_with_invalid_column
    begin
      @test_db.update('column', 'this', 'will fail')
    rescue Exception => ex
      assert_equal(ex.to_s, 'This column: column does not exist in the table')
    end
  end
  
  def test_delete_one_row
    @test_db.insert_row(column2: 1)
    @test_db.delete_rows('column2', 1)
    assert_equal(@test_db.database.size, 1)
    assert_equal(@test_db.database, [{"column1"=>"text", "column2"=>"int", "column3"=>"text", "id"=>0}])
  end
  def test_delete_multiple_rows
    @test_db.insert_row(column2: 1)
    @test_db.insert_row(column2: 1)
    @test_db.delete_rows('column2', 1)
    assert_equal(@test_db.database.size, 1)
    assert_equal(@test_db.database, [{"column1"=>"text", "column2"=>"int", "column3"=>"text", "id"=>0}])
  end

  def test_delete_with_no_table
    no_table = ORM::ORM.new('no table')
    begin
      no_table.delete_rows('column1', 'this will fail')
    rescue Exception => ex
      assert_equal(ex.to_s, 'You have not created a table. Please create a table then use this method')
    end
  end
  
  def test_delete_with_invalid_column
    begin
      @test_db.delete_rows('column', 'this will fail')
    rescue Exception => ex
      assert_equal(ex.to_s, 'This column: column does not exist in the table')
    end
  end

  def test_insert_csv
    file_path = __dir__ + '/test_sample.csv'

    @test_db.insert_csv(file_path)
    assert_equal(@test_db.database[1], {"id"=>1, "column1"=>"Nick", "column2"=>1, "column3"=>"Manfreda"})
    # # {"id"=>1, "column1"=>"Nick", "column2"=>1, "column3"=>"Manfreda"}
    # {"id"=>2, "column1"=>"Denver", "column2"=>2, "column3"=>"Colorado"}
    # {"id"=>3, "column1"=>"Chicago", "column2"=>3, "column3"=>"Illinois"})
  
  end
end
