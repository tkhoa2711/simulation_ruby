require_relative 'station'
#include Simulator

# Call initialization event
class CallInit
  def initialize(call_id, time, speed, station, position, duration)
    @id = call_id
    @time = time
    @speed  = speed
    @station = station
    @position = position
    @duration = duration
  end

  def execute
    "CallInit: id = #{@id}, time = #{@time}, station = #{@station}, position = #{@position}"
  end
end

# Call termination event
class CallTerminate
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