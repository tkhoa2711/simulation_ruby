require_relative 'parser'
require_relative 'rng'
require_relative 'station'
require_relative 'event'

# Simulation system
class Simulator
  attr_accessor :max_channel, :inter_arrival, :position, :duration, :speed

  @@station_number = 20
  @@channel_number = 10

  def initialize(max_channel = 10, max_station = 20)
    @max_channel = max_channel
    #@station = Array.new(10, Station)
    max_station.times {|index| @station[index] = Station.new(index)}
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

      @event[init_call] = method(:CallInit.execute)

      end_position = duration * speed + position

      puts @position.generate
      puts @duration.generate
      puts @speed.generate

      # Execute the event
      @clock.pop
    end
  end

  def run_2
    rng_init
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
    @time.size
  end
end




