# A general wrapper class for event handling
class Event
  def initialize
  end

  # Execute the event
  def execute

  end
end

# Call initialization event
class CallInit < Event
  def initialize(time, speed, station, position, duration)
    @time = time
    @speed  = speed
    @station = station
    @position = position
    @duration = duration
  end
end

# Call termination event
class CallTerminate < Event
  def initialize(time, station)
    @time = time
    @station = station
  end
end

# Call handover event
class Handover < Event
  def initialize(time, speed, station, duration)
    @time = time
    @speed = speed
    @station = station
    @duration = duration
  end
end