require_relative "../Turn"
require_relative "../RuleViolationError"
require "test/unit"

class TestTurn < Test::Unit::TestCase
  # Testet ob das Objekt richtig Initailisiert wird
  # Und ob der Inistanzierungsparameter auf Typ geprueft wird
  def test_initialize()
    t = Turn.new([1,2,3,4])
    assert(t)

    assert_raise(TypeError) do
      t = Turn.new("Hier sollte ein Array rein")
    end
    assert_raise(TypeError) do
      t = Turn.new(["Hier", "sollten", "Integers", "rein"])
    end

  end

  # Der Code, Black und White Hits duerfen nachtraeglich nicht geandert werden
  def test_manipulation()
    t = Turn.new([1,2,3,4])

    t.black_hits = 1
    t.white_hits = 1

    # Testen des ueberschreiben
    assert_raise(RuleViolationError) do
      t.black_hits = 2
    end
    assert_raise(RuleViolationError) do
      t.white_hits = 2
    end
    assert_equal(1, t.black_hits)
    assert_equal(1, t.white_hits)

    # Testen ob der Code geandert werden darf
    t.code.push(1)
    assert_equal([1,2,3,4], t.code)

  end

end