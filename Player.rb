#
# Superklasse eines Spielers
#


class Player
  def initialize(name)
    @name = name
  end

  def to_s()
    return "#{@name}"
  end
  
end