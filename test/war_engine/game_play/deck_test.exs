defmodule WarEngine.GamePlay.DeckTest do
  use ExUnit.Case

  alias WarEngine.GamePlay.Deck

  test "Deck.new creates a new shuffled deck of 52 cards" do
    deck = Deck.new()
    deck2 = Deck.new()

    assert length(deck) == 52
    refute deck == deck2
  end

  



end