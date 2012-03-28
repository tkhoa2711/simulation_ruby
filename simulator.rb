require_relative 'parser'
require_relative 'rng'
require_relative 'station'
require_relative 'event'

# Simulation system
class Simulator
  attr_accessor :max_channel, :inter_arrival, :position, :duration, :speed, :max_length, :max_station, :station

  @@station_number = 20
  @@channel_number = 10

  def initialize(max_channel = 10, max_station = 20, max_length = 4000)
    @max_station = max_station
    @max_channel = max_channel
    @max_length = max_length
    @channel_length = @max_length / @max_station
    #@station = Array.new(10, Station)
    @station = []
    0.upto(@max_station) {|index| @station[index] = Station.new(index)}
=begin
    for i in 0..19
      @station[i] = Station.new(i)
    end
=end
    # Distribution init

    @clock = Clock.new
    @event = Hash.new
  end

  def rng_init
    @inter_arrival = ExponentialDistribution.new(1.93)
    @position = UniformDistribution.new(0, 20)
    @duration = ExponentialDistribution.new(154.83)
    @speed = NormalDistribution.new(103.8, 16.9)
    @clock = Clock.new
    @event = Hash.new
    @time = 0
  end

  def run
    rng_init

    # Event loop execution
    while @clock.size
      # Find the next call information
      inter_arrival = @inter_arrival.generate
      duration = @duration.generate
      position = @position.generate
      speed = @speed.generate

      # The starting and ending time of a call
      init_call = @time + inter_arrival
      terminate_call = init_call + duration

      @clock.push [init_call, terminate_call]

      @event[init_call] = method(:CallInit::execute)

      end_position = duration * speed + position

      puts @position.generate
      puts @duration.generate
      puts @speed.generate

      # Execute the event
      @clock.pop
    end
  end

  # @param size [Object]
  def run_2(size)
    rng_init

    # Date generation
    size.times do |i|
      puts i
      # Generate new data
      inter_arrival = @inter_arrival.generate
      duration = @duration.generate
      position = @position.generate
      speed = @speed.generate

      # The starting and ending time of a call
      init_call = @time + inter_arrival
      terminate_call = init_call + duration
      puts init_call
      # Find the starting and ending stations of the call
      start_station = position.floor.quo(@channel_length)
      end_station = (position + duration * speed).floor.quo(@channel_length)

      # Check empty element in array => There should be some other better implementation ???
      # TODO: Alternative solution
      [init_call, terminate_call].each do |time|
        unless @event.has_key?(time)
          @event[time] = []
        end
      end

      # Add to event list when call is initiated and terminated
      call_init_event = CallInit.new(init_call, speed, start_station, position, duration)
      call_terminate_event = CallTerminate.new(terminate_call, end_station)
      @event[init_call] << call_init_event
      @event[terminate_call] << call_terminate_event

      # Find the moment when a handover happen during the call
      time_remain = duration
      time_to_next_station = (@channel_length - (position.floor % @channel_length)) / speed
      handover_call = @time + time_to_next_station

      # Add to the event list every time a handover happens
      while time_remain > time_to_next_station
        unless @event.has_key?(handover_call)
          @event[handover_call] = []
        end
        start_station += 1
        call_handover_event = CallHandover.new(handover_call, speed, start_station, 0)
        @event[handover_call] << call_handover_event
        time_to_next_station = @channel_length / speed
        handover_call += time_to_next_station
      end

      # Update the time for next call arrival
      @time += inter_arrival
      puts @time
    end

    # Sort the event queue
    @event = @event.sort_by {|time, event| time}

    # Execute the simulator
    start()
  end

  def start

    @event.each do |time, eventList|
      eventList.each do |event|
        event.execute
      end
    end
  end

  def init_call
    CallInit.execute
  end

  def terminate_call
    CallTerminate.execute
  end

  def handover_call
    CallHandover.execute
  end
end

class Clock
  def initialize
    @time = [0]
  end

  # Add new event execution time to clock
  def push(time)
    @time << time
    @time.sort
  end

  def pop
    @time.shift
  end

  def size
    @time.length
  end
end

a = Simulator.new
a.run_2(500)


