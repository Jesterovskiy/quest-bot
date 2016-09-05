require 'sequel'

DB = Sequel.sqlite('score_board.db')

if DB.tables.empty?
  DB.create_table :score_board do
    primary_key :id
    String :player
    Time :time
    String :additions
  end
end
