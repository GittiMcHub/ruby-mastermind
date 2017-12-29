require 'test/unit'

require_relative 'Turn'
require_relative 'Game'
require_relative "CodebreakerKIRandom"

class TestCodebreakerKIRandom < Test::Unit::TestCase
  def setup()

  end

  def test_ki()

    games = 1000
    game_code = Turn.new([1,1,2,2])
    
    setting_turns = 10
    setting_codelength = game_code.code.size()
    dummy_maker =  CodemakerHuman.new("Dummy")

    wins = 0
    turns_to_win = []


    (1..games).each do | i |
      game = Game.new(setting_codelength, setting_turns, dummy_maker, CodebreakerKIRandom.new("Captain Random"))
      game.set_code(game_code)

      while !game.finished?()
        begin
          turn = game.do_turn(game.player_breaker.guess(game))
          puts "Result #{turn.to_s()}"
        rescue TypeError, RuleViolationError => err
          puts "########################################"
          puts "Ups! #{err}"
          puts "########################################"
        end
      end

      if game.won?()
        wins += 1
        turns_to_win.push(game.turns.size())
      end

    end

    puts " ####################################  "
    puts " Captain Random won #{wins} times in #{games} games with an average of #{turns_to_win.sum() / turns_to_win.size()}"
    puts " ####################################  "
  end

end