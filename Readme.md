# Ruby Version
2.5.1

# Running the app
To see the example run `ruby example.rb`. 
<br />
To see the tests run `ruby test_orm.rb`

# Create database example
database = ORM::ORM.new('name_of_database')

# create_table
This takes the key as the name of the column and the value as the type. The only allowed types are 'int' and 'text'

# insert_row
This inserts a row into the database.
The key is the name of the column and the value is the record.
Errors will be thrown if an invalid type is inserted or a table has not been created.

# update
This updates all values in the column of the database based on the value passed
The first parameter is the name of the column, the second is the value to find,
and the thrid is the value to update it with.
Errors will be thrown if an invalid type is inserted or a table has not been created.

# delete_rows
This deletes all rows of the database based on the value and column passed.
The first parameter is the name of the column and the the second is the value to find.
Errors will be thrown if an invalid type is inserted or a table has not been created.

# insert_csv
Inserts all rows of the csv in the database using the insert row method.
Requires the full file path.
database.insert_csv(file_path)

# Example
The example.rb file contains a use of each of these methods.

