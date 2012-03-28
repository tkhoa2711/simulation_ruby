require_relative 'station'

# A general wrapper class for event handling
class Event
  def initialize
  end

  # Execute the event
  def execute

  end
end

# Call initialization event
class CallInit
  def initialize(time, speed, station, position, duration)
    @time = time
    @speed  = speed
    @station = station
    @position = position
    @duration = duration
  end

  def execute
    puts "CallInit"
    Statio
  end
end

# Call termination event
class CallTerminate
  def initialize(time, station)
    @time = time
    @station = station
  end

  def execute

  end
end

# Call handover event
class CallHandover
  def initialize(time, speed, station, duration)
    @time = time
    @speed = speed
    @station = station
    @duration = duration
  end

  def execute

  end
end