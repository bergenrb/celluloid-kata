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

  def create_item
    last_id = Db.insert
    row = Db.lookup(last_id)
    puts "[#{@process_key}] Created item with id: #{last_id} and data: #{row}"
    @last_created = row
    last_id
  end

  def start
    last_id = create_item
    notify_other(last_id)
  end

  def notify_other(id)
    pair_process.notify(id)
  end

  def notify(id)
    item = Db.lookup(id)
    puts "[#{@process_key}] Notified by pair process: #{id}. Looked up row with data: #{item}"
    pair_process.check_value(item[:value])
  end

  def check_value(value)
    result = @last_created && @last_created[:value] == value
    puts "[#{@process_key}] Check value: #{value}. Result: #{result}"

    after(5) { start }
  end
end

alpha = Actor.new(:alpha, :beta)
alpha.register

beta = Actor.new(:beta, :alpha)
beta.register

alpha.start

beta.start

if $0 == __FILE__
  loop do

  end
end
