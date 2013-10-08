require 'celluloid/autostart'

class Actor
  include Celluloid

  def initialize(process_key, pair_process_key)
    @process_key = process_key
    @pair_process_key = pair_process_key
  end

  def register
    Celluloid::Actor[@process_key] = Actor.current
  end

  def pair_process
    Celluloid::Actor[@pair_process_key] || raise
  end

  def create_item
  end

end

a1 = Actor.new(:a1, :a2)
a1.register

a2 = Actor.new(:a2, :a1)
a2.register
