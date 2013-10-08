require 'sequel'

$DB = Sequel.sqlite # memory database

$DB.create_table :items do
  primary_key :id
  String :value
end

$items = $DB[:items] # Create a dataset

class Db
  class << self
    def all
      $items.all
    end

    # Returns the id of the new item
    def insert(value=nil)
      a = ((0..9).to_a + ('a'..'z').to_a).shuffle
      value ||= 10.times.map { a.sample }.join
      puts value
      $items.insert(value: value)
    end

    def lookup(id)
      $DB['select * from items where id = ? LIMIT 1', id].first
    end
  end
end
