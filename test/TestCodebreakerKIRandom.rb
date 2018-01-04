require 'test/unit'

require_relative '../Turn'
require_relative '../Game'
require_relative '../CodebreakerKI'
require_relative '../CodebreakerKIRandom'
require_relative '../CodeMakerKI'

class TestCodebreakerKIRandom < Test::Unit::TestCase
  def setup()

    @dummy_maker =  CodemakerKI.new("TÜV Alt.F4")

    @amount_of_games = 100
    @setting_turns = 10
    @setting_range = 1..6
    @setting_length = 4

  end

  def play(game)
    while !game.finished?()
      game.next()
    end
    return game
  end

  # Testet ob Captin Random das Spiel beenden kann
  def test_ki()

    breaker = CodebreakerKIRandom.new("Captain Random")
    breaker.talking = false
    # Testen von vierstelligen codes
    game =  play(Game.new(@setting_length,@setting_range, @setting_turns, @dummy_maker,breaker))
    
    # Mindestens 1 Zug und das Spiel muss beendet sein
    assert_true(game.turns.size >= 1 && game.finished?() )
    
  end
end