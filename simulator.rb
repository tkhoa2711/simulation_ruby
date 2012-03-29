# require_relative 'parser'
# require_relative 'rng'
# require_relative 'station'
# require_relative 'event'
# Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }
%w{parser rng station}.each {|x| require_relative x}

# Call initialization event
class CallInit
  attr_reader :id

  def initialize(call_id, time, speed, station, position, duration)
    @id = call_id
    @time = time
    @speed  = speed
    @station = station
    @position = position
    @duration = duration
  end

  def execute
    #Simulator::Simulator.init_call_event(@station, @id)
    "CallInit: id = #{@id}, time = #{@time}, station = #{@station}, position = #{@position}"
  end
end

# Call termination event
class CallTerminate
  attr_reader :id

  def initialize(call_id, time, station)
    @id = call_id
    @time = time
    @station = station
  end

  def execute
    "CallTerm: id = #{@id}, time = #{@time}, station = #{@station}"
  end
end

# Call handover event
class CallHandover
  attr_reader :id

  def initialize(call_id, time, speed, station)
    @id = call_id
    @time = time
    @speed = speed
    @station = station
  end

  def execute
    "CallHand: id = #{@id}, time = #{@time}, station = #{@station}"
  end
end

module Simulator
# Simulation system
class Simulator
  def initialize(max_channel = 10, max_station = 20, max_length = 4000, max_reserved = 1)
    @max_station = max_station
    @max_channel = max_channel
    @max_length = max_length
    @max_reserved = max_reserved
    @channel_length = @max_length / @max_station
    #@station = Array.new(10, Station)
    @station = []
    1.upto(@max_station) {|index| @station[index] = Station.new(index, @max_channel, @max_length, @max_reserved)}
    (1..(@max_station - 1)).each {|i| @station[i].next = @station[i+1]}
    @event = Hash.new
    # Distribution init
  end

  def remove_from_queue(call_id)
    @event.each_value do |eventList|
      eventList.delete_if {|event| event.id == call_id}
    end
  end

  # Block a call -> delete any event from the queue with the same call_id
  def block_call(call_id)
    @blocked_num += 1
    remove_from_queue(call_id)
  end

  def drop_call(call_id)
    @dropped_num += 1
    remove_from_queue(call_id)
  end

  def init_call_event(call_id, station)
    puts 'init_call_event'
    unless @station[station].acquire_channel(call_id)
      block(call_id)
      return false
    end
    return true
  end

  def terminate_call_event(call_id, station)
    @station[station].release_channel(call_id)
  end

  def handover_event(call_id, station)
    @station[station].release(call_id)
    unless @station[station].next.acquire_channel(call_id)
      unless @station[station].next.acquire_reserved(call_id)
        drop_call(call_id)
        return false
      end
    end
    @handover_num += 1
    return true
  end

  def rng_init
    @inter_arrival = ExponentialDistribution.new(1.93)
    @position = UniformDistribution.new(0, 2000)
    @base_station = UniformDistribution.new(0, 20)
    @duration = ExponentialDistribution.new(154.83)
    @speed = NormalDistribution.new(103.8, 16.9)
    @event = Hash.new
    @time = 0.0
    @dropped_num = 0
    @blocked_num = 0
    @handover_num = 0
  end

  def generate_data(size)
    size.times do |i|
      puts "i = #{i}"
      # Create a unique ID for a call
      id = i
      inter_arrival = @inter_arrival.generate
      duration = @duration.generate
      position = @position.generate
      speed = @speed.generate

      # The starting and ending time of a call
      init_call = @time + inter_arrival
      terminate_call = init_call + duration

      # Find the starting and ending stations of the call
      # start_station = position.floor.quo(@channel_length).to_i
      # end_station = (position + duration * speed).floor.quo(@channel_length).to_i
      start_station = @base_station.generate
      end_station = start_station + (duration * speed).floor.quo(@channel_length).to_i

      # Check empty element in array => There should be some other better implementation ???
      # TODO: Alternative solution
      [init_call, terminate_call].each do |time|
        unless @event.has_key?(time)
          @event[time] = []
        end
      end

      # Add to event list when call is initiated and terminated
      call_init_event = CallInit.new(id, init_call, speed, start_station, position, duration)
      call_terminate_event = CallTerminate.new(id, terminate_call, end_station)
      @event[init_call] << call_init_event
      @event[terminate_call] << call_terminate_event

      # Find the moment when a handover happen during the call
      time_remain = duration
      time_to_next_station = (@channel_length - (position.floor % @channel_length)) / speed
      handover_call = @time + time_to_next_station

      # Add to the event list every time a handover happens
      while time_remain > handover_call
        unless @event.has_key?(handover_call)
          @event[handover_call] = []
        end
        start_station += 1
        call_handover_event = CallHandover.new(id, handover_call, speed, start_station)
        @event[handover_call] << call_handover_event
        time_to_next_station = @channel_length / speed
        handover_call += time_to_next_station
      end

      # Update the time for next call arrival
      @time += inter_arrival
      print "time = ",@time,"\n"
    end

    # Sort the event queue
    @event = @event.sort

    # Write to file
    File.open("data.txt", "w") do |file|
      @event.each do |event|
        file.write(event)
      end
    end
  end

  # Start the event simulation
  def simulate
    File.open("output.txt", "w") do |file|
      @event.each do |time, eventList|
        eventList.each do |event|
          file.puts "#{event.execute}"
        end
      end
    end
  end

  # @param size [Object]
  def run(size)
    rng_init
    generate_data(size)
    simulate
    puts "Dropped: #{@dropped_num}, Blocked: #{@blocked_num}, Handover: #{@handover_num}"
  end
end



a = Simulator.new
a.run(10000)

end
