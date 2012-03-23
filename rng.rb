# A general distribution class wrapper
class ProbabilityDistribution
  def initialize
  end

  # Generate random numbers
  def rng(n = 1)
    if n < 1
      return "At least 1 random numbers to be generated!"
    end
    if n > 1
      rand_num = []
      for i in (0..n)
        rand_num[i] = get_rng()
      end
      # Return an array of random numbers
      return rand_num
    else
      # Return one random number
      return get_rng()
    end
  end

  def mean
    get_mean
  end
end

# Normal Distribution
class NormalDistribution < ProbabilityDistribution
  def initialize(mean = 0.0, std_dev = 1.0)
    if std_dev < 0
      return "error"
    end
    @mean = mean
    @std_dev = std_dev
    @variance = @std_dev * 2
  end

  def get_mean
    @mean
  end
end

# Uniform Distribution
class UniformDistribution
  def initialize(min = 0.0, max = 0.0)
    if min > max
      return "error"
    end
    @min = min
    @max = max
    @range = @max - @min
  end

  def generate
    @min + @range * rand(1)
  end
end

# Exponential Distribution
class ExponentialDistribution
  def initialize(decay = 1.0)
    if decay < 0.0
      raise ArgumentError.new("Decay parameter for exponential distribution should be positive!")
    end
    @decay = decay
  end
end