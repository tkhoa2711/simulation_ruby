#require 'Math'
#require 'Random'

# A general distribution class wrapper
class ProbabilityDistribution
  attr_reader :sum, :size, :average

  def initialize(sample)
    @sum = sample.sum
    @size = sample.length
    @average = @sum.to_f / @size
    # A number of way to calculate the average of an array:
    # sample.inject{ |sum, element| sum + element }.to_f / sample.length
    # ------
    # sample.inject(0.0) { |sum, element| sum + element } / sample.length
    # ------
    # sample.inject(:+).to_f / sample.length
  end

end

# Normal Distribution
class NormalDistribution
  def initialize(mean = 0.0, std_dev = 1.0)
    if std_dev < 0
      return "error"
    end
    @mean = mean
    @std_dev = std_dev
    @variance = @std_dev * 2
  end

  def generate
    # mean = 1.0, std_dev = 0.5
    # Array.new(1000) { 1 + Math.sqrt(-2 * Math.log(rand)) * Math.cos(2 * Math::PI * rand) }

    # Box_Muller transform method to generate Gaussian distribution
    # y1 = sqrt( - 2 ln(x1) ) cos( 2 pi x2 )
    # y2 = sqrt( - 2 ln(x1) ) sin( 2 pi x2 )
    #rand_num = Random.rand
    #puts rand_num
    #theta = 2 * Math::PI * Kernel.rand.callcc

    # Polar form of Box_Muller transform method to generate Gaussian distribution
    # To speed up repeated RNG computations, two random values
    # are computed after the while loop and the second one is saved and
    # directly used if the method is called again.
    # see http://www.taygeta.com/random/gaussian.html
    # returns single normal deviate
    # float x1, x2, w, y1, y2;
    #      do {
    #              x1 = 2.0 * ranf() - 1.0;
    #              x2 = 2.0 * ranf() - 1.0;
    #              w = x1 * x1 + x2 * x2;
    #      } while ( w >= 1.0 );
    #
    #      w = sqrt( (-2.0 * ln( w ) ) / w );
    #      y1 = x1 * w;
    #      y2 = x2 * w;
    # randf() routine to obtain a random number uniformly distributed in [0,1]
    if @use_last
      y1 = @last
      @use_last = false
    else
      w = 1
      until w < 1.0 do
        r1 = Kernel.rand
        r2 = Kernel.rand
        x1 = 2.0 * r1 - 1.0
        x2 = 2.0 * r2 - 1.0
        w  = x1 * x1 + x2 * x2
      end
      w = Math.sqrt((-2.0 * Math.log(w)) / w)
      y1 = x1 * w
      @last = x2 * w
      @use_last = true
    end
    return @mean + y1 * Math.sqrt(@variance)
  end

  def get_mean
    @mean
  end
end

# Uniform Distribution
class UniformDistribution
  def initialize(min = 0.0, max = 1.0)
    if min > max
      return "error"
    end
    @min = min
    @max = max
    @range = @max - @min
  end

  def generate
    @min + Kernel.rand(@max)
  end
end

# Exponential Distribution
class ExponentialDistribution
  def initialize(rate = 1.0)
    if rate < 0.0
      raise ArgumentError.new("Decay parameter for exponential distribution should be positive!")
    end
    @rate = rate
  end

  def generate
    return -Math.log(1 - Kernel.rand) * @rate
  end
end

# Class for testing of distributions
class DistributionTest
  def initialize(distribution)

  end

  # Estimation of parameters for a distribution
  # Using MLE (Maximum-likelihood estimator)
  def parameter_estimation(type, *beta)
    if type == 'exponential'
      beta = sample.sum / sample.length
    end
  end

  def test_exponential(distribution)
    rate = distribution.average
    critical_value = rate / Math.sqrt(distribution.length)
    #d_plus =
  end

  def test_normal(distribution)
    mean = distribution.sum / distribution.length
    #std_dev = s
  end

  def chi_square_test
    alpha
  end
end


a = NormalDistribution.new(1.0, 1.5)
b = UniformDistribution.new(0, 100)
c = ExponentialDistribution.new(1.0)

10000.times do
  #puts a.generate
end
