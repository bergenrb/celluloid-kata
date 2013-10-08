require 'celluloid/autostart'

require './db'

class Actor
  include Celluloid

  def initialize(process_key, pair_process_key)
    @process_key = process_key
    @pair_process_key = pair_process_key
  end

  def register
    Celluloid::Actor[@process_key] = Actor.current
  end

  # Lookup the this process'
  def pair_process
    Celluloid::Actor[@pair_process_key] || raise
  end

  def start
    create_item
  end

  def create_item
    last_id = Db.insert
    puts "Created item with id: #{last_id}"
  end
end

a1 = Actor.new(:a1, :a2)
a1.register

a2 = Actor.new(:a2, :a1)
a2.register

a1.start
a2.start

loop do

end
