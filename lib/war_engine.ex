defmodule WarEngine do
  alias WarEngine.GamePlay.Game
  @moduledoc """
  Documentation for WarEngine.
  """

  @doc """
  Start a new game by delegating the new_game(id) function to the Game module

  ## Examples

    iex> {:ok, pid} = WarEngine.new_game(2)
    {:ok, #PID<0.154.0>}

  """
  defdelegate new_game(id), to: Game

end
