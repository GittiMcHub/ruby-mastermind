require 'test/unit'

require_relative 'Turn'
require_relative 'Game'

class TestCodebreakerKI < Test::Unit::TestCase
  def setup()

    @dummy_maker =  CodemakerHuman.new("TÜV Alt.F4")

    @amount_of_games = 100
    @setting_turns = 10
    @setting_range = 1..6

    @game_code2a = Turn.new([2,2])
    @game_code2b = Turn.new([3,3])

    @game_code3a = Turn.new([3,3,3])
    @game_code3b = Turn.new([5,5,5])

    @game_code4a = Turn.new([6,6,6,6])
    @game_code4b = Turn.new([2,2,2,2])

  end

  def play(turn)

    game = Game.new(turn.code.size(),@setting_range, @setting_turns, @dummy_maker, CodebreakerKI.new("Crashtest Dummy"))
    game.set_code(turn)

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

      game2a = play(@game_code2a)
      game2b = play(@game_code2b)

      if game2a.won?
        wins_code2 += 1
        turns_to_win_code2.push(game2a.turns.size())
      end
      if game2b.won?
        wins_code2 += 1
        turns_to_win_code2.push(game2b.turns.size())
      end

      # Testen von dreistelligen Codes
      game3a = play(@game_code3a)
      game3b = play(@game_code3b)

      if game3a.won?
        wins_code3 += 1
        turns_to_win_code3.push(game3a.turns.size())
      end
      if game3b.won?
        wins_code3 += 1
        turns_to_win_code3.push(game3b.turns.size())
      end
      # Testen von vierstelligen codes
      game4a = play(@game_code4a)
      game4b = play(@game_code4b)

      if game4a.won?
        wins_code4 += 1
        turns_to_win_code4.push(game4a.turns.size())
      end
      if game4b.won?
        wins_code4 += 1
        turns_to_win_code4.push(game4b.turns.size())
      end
    end

    puts " ####################################  "
    puts " 2-digit codes: KI won #{wins_code2} of #{@amount_of_games*2} games with an average of #{turns_to_win_code2.sum.to_f() / turns_to_win_code2.size.to_f()}"
    puts " 3-digit codes: KI won #{wins_code3} of #{@amount_of_games*2} games with an average of #{turns_to_win_code3.sum.to_f() / turns_to_win_code3.size.to_f()}"
    puts " 4-digit codes: KI won #{wins_code4} of #{@amount_of_games*2} games with an average of #{turns_to_win_code4.sum.to_f() / turns_to_win_code4.size.to_f()}"
    puts " ####################################  "
  end

end