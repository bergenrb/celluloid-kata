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
    last_id = create_item
    notify_other(last_id)
  end

  def notify_other(id)
    pair_process.async.notify(id)
  end

  def notify(id)
    puts "[#{@process_key}] Notified by pair process: #{id}"
  end

  def create_item
    last_id = Db.insert
    puts "[#{@process_key}] Created item with id: #{last_id}"
    last_id
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
