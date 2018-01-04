require 'test/unit'

require_relative '../Turn'
require_relative '../Game'
require_relative '../CodebreakerKI'
require_relative '../CodebreakerKIRandom'
require_relative '../CodeMakerKI'

class TestCodebreakerKI < Test::Unit::TestCase
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

  def test_ki_performance()

    wins = 0
    turns_to_win = []

    # Testen von zweistelligen Codes
    @amount_of_games.times do
    
      # Testen von vierstelligen codes
      breaker = CodebreakerKI.new("Fortuna")
      breaker.talking = false
      game =  play(Game.new(@setting_length,@setting_range, @setting_turns, @dummy_maker, breaker))
      print "."
      if game.won?
        wins += 1
        turns_to_win.push(game.turns.size())
      end
    end

    puts "\n 4-digit codes: KI won #{wins} of #{@amount_of_games} games with an average of #{turns_to_win.sum.to_f() / turns_to_win.size.to_f()}"
    # Sollte in mindestens 40% der Fälle gewinnen
    assert_true((wins.to_f() / @amount_of_games.to_f()) > 0.4 )
    # aber niemals zu 100% -> Sonst waere die KI Langweilig...
    assert_true((wins.to_f() / @amount_of_games.to_f()) < 0.9 )
  end

end