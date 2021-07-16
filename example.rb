require "./orm"

#Creates database
example_database = ORM::ORM.new('nick')
example_database.create_table(column1: 'text', column2: 'int', column3: 'text')

example_database.insert_row(column1: 'first row', column2: 1 )
example_database.insert_row(column1: 'second row', column2: 2 )

example_database.update('column1', 'second row', 'is awesome')

example_database.delete_rows('column1', 'first row')

file_path = __dir__ + '/test_sample.csv'
example_database.insert_csv(file_path)

# This will display the header row and the 4 rows of value
puts example_database.database

