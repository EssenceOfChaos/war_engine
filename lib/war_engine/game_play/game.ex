defmodule WarEngine.GamePlay.Game do
  alias WarEngine.GamePlay.{Server}
  
  defstruct user_id: :none,
            user_cards: :empty,
            computer_cards: :empty,
            status: :uninitialized


  def start_link() do
    Agent.start_link(fn -> initialize_game() end)
  end

  defp initialize_game() do
    Server.start_link
  end



end