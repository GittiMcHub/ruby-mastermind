require 'test/unit'

require_relative '../Turn'
require_relative '../Game'
require_relative '../CodebreakerKI'
require_relative '../CodebreakerKIRandom'
require_relative '../CodeMakerKI'

class TestCodebreakerKI < Test::Unit::TestCase
  
  def setup()
    @code_length = 4
    @code_range = 1..6
    @allowed_turns = 10
    @maker = CodemakerKI.new("Alt.F4 TÜV Maker")
    @breaker = CodebreakerKI.new("Alt.F4 TÜV Breaker")
  end
  
  
  def test_initialize_defeaults()
    game = Game.new()
    assert(game)
  end
  
  def test_initialize()
    game = Game.new(@code_length, @code_range, @allowed_turns, @maker, @breaker)
  end
  
  
  def test_gameplay()
    game = Game.new(@code_length, @code_range, @allowed_turns, @maker, @breaker)
    
    while !game.finished?()
      game.next()
    end
    
  end
  
end