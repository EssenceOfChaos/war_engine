defmodule WarEngine.GamePlay.Game do
  alias WarEngine.GamePlay.{Server}
  
  defstruct user_id: :none,
            user_cards: :empty,
            computer_cards: :empty,
            status: :uninitialized


  def new_game(id) do
    Server.start_link(id)
  end

end