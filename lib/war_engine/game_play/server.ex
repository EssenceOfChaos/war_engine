defmodule WarEngine.GamePlay.Server do
  use GenServer
  alias WarEngine.GamePlay.{Server, Deck, Game}
    @moduledoc """
    Documentation for WarEngine.GamePlay.Server
    """

    @doc """
    Start each game in its own process named after the "game: id"
    """

  # Client API
  def start_link(id) do
    GenServer.start_link(__MODULE__, :ok, name: {:global, "game:#{id}"})
  end

    @doc """
      Retrieve the current state of the game (requires pid)

    ## Examples
    
     iex> Server.read(pid)

      %WarEngine.GamePlay.Game{computer_cards: [{12, :hearts}, {6, :hearts},
      {13, :spades}, {6, :spades}, {10, :hearts}, {7, :clubs}, {10, :spades},
      {5, :clubs}, {11, :hearts}, {3, :diamonds}, {11, :clubs}, {3, :spades},
      {10, :diamonds}], status: "in progress",
      user_cards: [{2, :spades}, {13, :hearts}, {5, :hearts}, {14, :diamonds},
      {7, :spades}, {12, :spades}, {5, :spades}, {9, :clubs}, {3, :hearts},
      {12, :clubs}, {7, :hearts}, {14, :clubs}, {6, :clubs}, {13, :clubs},
      {6, :diamonds}, {11, :spades}, {4, :spades}, {14, :spades}, {7, :diamonds},
      {9, :diamonds}, {3, :clubs}, {14, :hearts}, {2, :clubs}, {10, :clubs},
      {2, :hearts}, {12, :diamonds}, {5, :diamonds}, {11, :diamonds},
      {4, :diamonds}, {13, :diamonds}, {2, :diamonds}], user_id: :none}

    """
  def read(pid) do
    GenServer.call(pid, :read)
  end

    @doc """
    Compares both the user and the computers top cards

  ## Examples

    iex> Server.turn(pid)

    "User wins with 9!"

  """
  def turn(pid) do
    GenServer.call(pid, :turn)
  end

  # Server Callbacks
  def init(:ok) do
    {:ok, load()}
  end

  defp load() do
    deck = Deck.new
    cards = Enum.take_random(deck, 26)
    comp = deck -- cards
   %Game{
     user_cards: cards |> Enum.map(&to_tuple/1),
     status: "in progress",
     computer_cards: comp |> Enum.map(&to_tuple/1),
       }
  end

  defp to_tuple(
    %Deck.Card{value: value, suit: suit}
    ), do: {value, suit}


  def handle_call(:read, _from, state) do
    {:reply, state, state}
  end

  def handle_call(
    :turn,
    _from,
    %Game{
      user_cards: [{user_card, user_card_suit} | user_cards_rest],
      computer_cards: [{computer_card, computer_card_suit} | computer_cards_rest]
    } = state
  ) do
    
    cond do
      user_card > computer_card ->
        new_state = Map.merge(state, %{
          user_cards: user_cards_rest ++ [{computer_card, computer_card_suit}, {user_card, user_card_suit}],
          computer_cards: computer_cards_rest
        })
      {:reply, "User wins with #{user_card}!", new_state}

      computer_card > user_card ->
        new_state = Map.merge(state, %{
          computer_cards: computer_cards_rest ++ [{user_card, user_card_suit}, {computer_card, computer_card_suit}],
          user_cards: user_cards_rest
        })
      {:reply, "Computer wins with #{computer_card}!", new_state}
## TODO: fix war logic
      user_card == computer_card ->
        # war occurs
        new_state = Map.merge(state, %{
          computer_cards: computer_cards_rest,
          user_cards: user_cards_rest
        })
      {:reply, "War occurs with #{user_card} vs. #{computer_card}!", new_state}
    end
  end


  def handle_call(:turn, _from, %Game{computer_cards: []} = state) do
    #user wins logic
    new_state = Map.put(state, :status, :won)
    {:reply, "User wins!", new_state}
  end

  def handle_call(:turn, _from, %Game{user_cards: []} = state) do
    #user lose logic
    new_state = Map.put(state, :status, :lost)
    {:reply, "User Lost!", new_state}
  end

end
