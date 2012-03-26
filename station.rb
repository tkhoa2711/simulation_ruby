
class Station
  attr_accessor :max_channel, :max_length, :num_channel, :max_reserve, :num_reserve
  attr_reader :id

  # Initialize a base station with a specific id
  def initialize(id)
    if id < 0
      return "error"
    end
    @id = id
    @max_channel = 10
    @max_reserve = 1
    @max_length = 2000
    @num_channel = 0
    @num_reserve = 0
  end

  # Acquire new channel
  def acquire_channel
    if @num_channel > @max_channel
      puts "Maximum number of channel exceeded!"
      return false
    end
    if not free_channel_avail and not free_reserve_avail
      puts "No more channel for acquiring!"
      return false
    end
    @num_channel += 1
    puts "New channel acquired."
    return true
  end

  # Acquire a handover
  def acquire_handover
    if not free_channel_avail
      puts "No free channel available for handover"
      return false
    end
    @num_channel += 1
    @num_reserve += 1
    puts "New handover"
    return true
  end

  # Release a channel
  def release_channel
    if @num_channel == 0
      puts "all channel are released!"
      return false
    end
    puts "Channel release at station ", @id
    @num_channel -= 1
    return true
  end

  # Release a handover
  def release_handover
    if @num_channel == 0
      puts "all channel are released!"
      return false
    end
    puts "Channel (handover) release at station ", @id
    @num_channel -= 1
    @num_reserve -= 1
    return true
  end

  def free_channel_avail
    return @max_channel - @num_channel
  end

  def free_reserve_avail
    return @max_reserve - @num_reserve
  end
end