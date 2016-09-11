require 'sequel'

REDIS = Redis.connect
DB = Sequel.connect(ENV['DATABASE_URL'])

if DB.tables.empty?
  DB.create_table :score_board do
    primary_key :id
    String :player
    Time :time
    String :additions
  end
end
