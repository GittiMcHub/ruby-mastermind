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
  end

  def play_with_code_length(setting_code_length)

    game = Game.new(setting_code_length,@setting_range, @setting_turns, @dummy_maker, CodebreakerKIRandom.new("Captain Random"))
    game.set_code(@dummy_maker.create_code(game))

    while !game.finished?()
      begin
        turn = game.do_turn(game.player_breaker.guess(game))
      rescue TypeError, RuleViolationError => err
        puts "########################################"
        puts "Ups! #{err}"
        puts "########################################"
      end
    end
    return game
  end

  def test_ki()

    wins_code2 = 0
    wins_code3 = 0
    wins_code4 = 0

    turns_to_win_code2 = []
    turns_to_win_code3 = []
    turns_to_win_code4 = []

    # Testen von zweistelligen Codes
    (1..@amount_of_games).each do | i |

      game2 = play_with_code_length(2)
      if game2.won?
        wins_code2 += 1
        turns_to_win_code2.push(game2.turns.size())
      end

      # Testen von dreistelligen Codes
      game3 = play_with_code_length(3)
      if game3.won?
        wins_code3 += 1
        turns_to_win_code3.push(game3.turns.size())
      end

      # Testen von vierstelligen codes
      game4 = play_with_code_length(4)
      if game4.won?
        wins_code4 += 1
        turns_to_win_code4.push(game4.turns.size())
      end
    end

    puts " ####################################  "
    puts " 2-digit codes: KI won #{wins_code2} of #{@amount_of_games} games with an average of #{turns_to_win_code2.sum.to_f() / turns_to_win_code2.size.to_f()}"
    puts " 3-digit codes: KI won #{wins_code3} of #{@amount_of_games} games with an average of #{turns_to_win_code3.sum.to_f() / turns_to_win_code3.size.to_f()}"
    puts " 4-digit codes: KI won #{wins_code4} of #{@amount_of_games} games with an average of #{turns_to_win_code4.sum.to_f() / turns_to_win_code4.size.to_f()}"
    puts " ####################################  "
  end

end