
class Station
  attr_accessor :max_channel, :max_length, :max_reserved, :free_channel, :reserved_channel, :next
  attr_reader :id

  # Initialize a base station with a specific id
  def initialize(id, max_channel, max_length, max_reserved)
    @id = id
    @max_channel = max_channel
    @max_length = max_length
    @max_reserved = max_reserved
    @max_free = @max_channel - @max_reserved
    @free_channel = []
    @reserved_channel = []
    @next = nil
  end

  # Acquire new available free channel
  def acquire_channel(call_id)
    unless avail_free_channel
      puts "No more channel for acquiring!"
      return false
    end
    @free_channel << call_id
    puts "New channel acquired from station #{@id}."
    return true
  end

  # Acquire a reserved channel for handover
  def acquire_reserved(call_id)
    if not avail_free_channel
      puts "No free channel available for handover"
      return false
    end
    @reserved_channel << call_id
    puts "New handover from station #{@id}"
    return true
  end

  # Release a channel acquired by a @param call_id
  def release_channel(call_id)
    if @free_channel.delete(call_id) == call_id
      "Free channel released at station #{@id}"
      return true
    end
    if @reserved_channel.delete(call_id) == call_id
      puts "Channel (handover) release at station #{@id}"
      return true
    end
    return false
  end

  def avail_free_channel
    return @max_free - @free_channel.length
  end

  def avail_reserved_channel
    return @max_reserved - @reserved_channel.length
  end
end