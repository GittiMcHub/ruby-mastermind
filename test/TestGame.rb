require 'test/unit'

require_relative '../RuleViolationError'
require_relative '../Turn'
require_relative '../Game'
require_relative '../CodebreakerKI'
require_relative '../CodebreakerKIRandom'
require_relative '../CodeMakerKI'

class TestCodebreakerKI < Test::Unit::TestCase
  def setup()

    # Standard regeln
    @code_length = 4
    @code_range = 1..6
    @allowed_turns = 10
    @maker = CodemakerKI.new("Alt.F4 TÜV Maker")
    @breaker = CodebreakerKI.new("Alt.F4 TÜV Breaker")
    @game = Game.new(@code_length, @code_range, @allowed_turns, @maker, @breaker)

  end

  # Pruefen, ob das Spiel mit korrekten Standardeinstellungen initialisiert wird
  def test_initialize_defaults()

    game = Game.new()
    assert(game)
    assert_equal(@code_length, game.setting_code_length)
    assert_equal(@code_range, game.setting_code_range)
    assert_equal(@allowed_turns, game.setting_turns)

  end

  # Pruefen, ob das Spiel mit den obigen Einstellungen instanziert wird
  def test_initialize()

    game = Game.new(@code_length, @code_range, @allowed_turns, @maker, @breaker)
    assert(game)
    assert_equal(@code_length, game.setting_code_length)
    assert_equal(@code_range, game.setting_code_range)
    assert_equal(@allowed_turns, game.setting_turns)
    assert_equal(@maker, game.player_maker)
    assert_equal(@breaker, game.player_breaker)

    # Pruefen ob mit Falschen Typen instanziert werden kann
    assert_raise(TypeError) do
      Game.new("Codelaenge als INT", "Zahlenbereich als RANGE", "Anzahl Zuege als INT", "Maker als Player", "Breaker als Player")
    end
    assert_raise(TypeError) do
      Game.new("Codelaenge als INT", @code_range, @allowed_turns, @maker, @breaker)
    end
    assert_raise(TypeError) do
      Game.new(@code_length, "Zahlenbereich als RANGE", @allowed_turns, @maker, @breaker)
    end
    assert_raise(TypeError) do
      Game.new(@code_length, @code_range, "Anzahl Zuege als INT", @maker, @breaker)
    end
    assert_raise(TypeError) do
      Game.new(@code_length, @code_range, @allowed_turns, "Maker als Player", @breaker)
    end
    assert_raise(TypeError) do
      Game.new(@code_length, @code_range, @allowed_turns, @maker, "Breaker als Player")
    end

  end

  # Die beiden KIs muessen das Spiel zuenndespielen koennen
  def test_gameplay()

    while !@game.finished?()
      @game.next()
    end
    # Entweder wurde das Spiel gewonnen mit mindestens einem Zug, oder 10 zuege gebraucht bei einer Niederlage
    assert_true(( (@game.won?() && @game.turns.size() >= 1) || (@game.turns.size() == 10 && !@game.won?()) ))

  end

  # Testet ob das Spiel mit dem richtigen Code auch als Gewonnen gilt
  def test_won_and_finished()

    @game.set_code(Turn.new([1,2,3,4]))
    assert_false(@game.won?())
    assert_false(@game.finished?())
    @game.do_turn(Turn.new([1,2,3,4]))
    assert_true(@game.won?())
    assert_true(@game.finished?())

  end

  # Testet ob das Spiel verloren wird, wenn 10 zuege geamcht wurden
  def test_lost_and_finished()
    @game.set_code(Turn.new([1,2,3,4]))
    assert_false(@game.finished?())

    @allowed_turns.times do
      @game.do_turn(Turn.new([1,1,1,1]))
    end

    assert_equal(@allowed_turns, @game.turns.size())

    assert_false(@game.won?())
    assert_true(@game.finished?())

  end

  # Pruefen, ob Fixe Spielelemente nach der Instanzierung geaenderet werden koennen
  def test_game_manipluations

    assert_raise(NoMethodError) do
      @game.setting_code_length = 10
    end
    assert_raise(NoMethodError) do
      @game.setting_turns = 100
    end
    assert_raise(NoMethodError) do
      @game.setting_code_range = 1..10
    end
    assert_raise(NoMethodError) do
      @game.code = 1..10
    end
    assert_raise(NoMethodError) do
      @game.turns = [1,2,3,4]
    end
    assert_raise(NoMethodError) do
      @game.player_maker = nil
    end
    assert_raise(NoMethodError) do
      @game.player_breaker = nil
    end
    
    actual_amount_of_turns = @game.turns.size()
    @game.turns.push("ToxicObject")
    # Das Zurueckgegebene Array darf nicht ermoelgichen, in das Spiel einzugreifen
    assert_false(@game.turns.include?("ToxicObject"))
    # Auch die Groesse der Zuege darf sich nicht aendern, wenn mit dem Rueckgabewert gearbeitet wird
    # Das ist essentiell fuer das korrekte Bestimmen des Spielendes
    assert_equal(actual_amount_of_turns, @game.turns.size())

  end

  # Pruefen, ob die Regeln eingehalten werden

  # Pruefen, ob der Code nach dem setzen geaendert werden kann
  def test_rule_code_set_only_once()
    @game.set_code(Turn.new([1,2,3,4]))
    # Jetzt muesste eine Regelverletzung kommen
    assert_raise(RuleViolationError) do
      @game.set_code(Turn.new([1,2,3,4]))
    end
    
    @game.do_turn(Turn.new([1,2,3,4]))
      
    # Nachdem das Spiel beendet wurde, darf der Code auch nicht geandert werden
    assert_true(@game.finished?())
    @game.code.push(9)
    assert_false(@game.code.include?(9))
    
  end

  #Testet die Code laenge und Range
  def test_rule_code_length_and_range()
    # Jetzt muesste eine Regelverletzung kommen, da die Codeleange auf 4 gesetzt ist
    assert_raise(RuleViolationError) do
      @game.set_code(Turn.new([1,2,3,4,5,6]))
    end
    # Jetzt muesste eine Regelverletzung kommen, da die Coderange auf 1..6 gesetzt ist
    assert_raise(RuleViolationError) do
      @game.set_code(Turn.new([9,9,9,9]))
    end
  end

  # Testet ob nach dem Spielende noch ein Zug gemacht werden kann
  def test_rule_no_turns_after_finish()
    test_lost_and_finished()
    assert_raise(RuleViolationError) do
      @game.do_turn(Turn.new([1,1,1,1]))
    end
  end

  # Testet ob der Code eingesehen werden kann, bevor das Spiel beendet wurde
  def test_rule_expose_code_after_finish()
    @game.set_code(Turn.new([1,2,3,4]))

    assert_raise(RuleViolationError) do
      @game.code
    end
    
    @game.do_turn(Turn.new([1,2,3,4]))
    assert(@game.code)

  end
  
end