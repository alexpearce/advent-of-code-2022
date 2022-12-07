defmodule Solution do
  # Result of playing my hand against an opponent.
  @result_matrix %{
    rock: %{rock: :draw, paper: :lose, scissors: :win},
    paper: %{rock: :win, paper: :draw, scissors: :lose},
    scissors: %{rock: :lose, paper: :win, scissors: :draw},
  }
  # Hand to play for the desired outcome.
  # This the same as the result matrix but with the inner maps inverted.
  @outcome_matrix Map.new(@result_matrix, fn {key, val} -> {key, Map.new(val, fn {key, val} -> {val, key} end)} end)

  def part1() do
    input_stream()
      |> Enum.map(&line_to_hands/1)
      |> Enum.map(&hands_to_score/1)
      |> Enum.sum
  end

  def part2() do
    input_stream()
      |> Enum.map(&line_to_hands_from_strategy/1)
      |> Enum.map(&hands_to_score/1)
      |> Enum.sum
  end

  defp input_stream() do
    File.stream!("02/input.txt")
  end
  
  defp line_to_hands(line) do
    character_hands = %{
      "A" => :rock,
      "B" => :paper,
      "C" => :scissors,
      "X" => :rock,
      "Y" => :paper,
      "Z" => :scissors,
    }
    line
      |> String.trim
      |> String.split(" ")
      |> Enum.map(&Map.fetch!(character_hands, &1))
  end
  
  defp line_to_hands_from_strategy(line) do
    character_hands = %{
      "A" => :rock,
      "B" => :paper,
      "C" => :scissors,
    }
    [opponent_hand_char, my_hand_char] = line
      |> String.trim
      |> String.split(" ")
    opponent_hand = character_hands[opponent_hand_char]
    my_hand = strategy_hand(opponent_hand, my_hand_char)
    [opponent_hand, my_hand]
  end
  
  defp hands_to_score([opponent_hand, my_hand]) do
    contest_score(opponent_hand, my_hand) + hand_score(my_hand)
  end
  
  # Score of playing my hand against my opponent's hand.
  defp contest_score(opponent_hand, my_hand) do
    result_score(@result_matrix[my_hand][opponent_hand])
  end
  
  # Scores of my outcome
  defp result_score(:lose), do: 0
  defp result_score(:draw), do: 3
  defp result_score(:win), do: 6
  
  # Scores of my hand
  defp hand_score(:rock), do: 1
  defp hand_score(:paper), do: 2
  defp hand_score(:scissors), do: 3
  
  defp strategy_hand(opponent_hand, strategy_char) do
    # These strategies are the opposite of their meaning in the puzzle.
    # This is because the outcome matrix gives the hand to play against
    # its first dimension; here that dimension is the opponent's hand,
    # and so we play the opposite strategy (the opponent's) to ours.
    strategy = %{"X" => :win, "Y" => :draw, "Z" => :lose}[strategy_char]
    @outcome_matrix[opponent_hand][strategy]
  end
end

IO.puts "Total score with assumed hands: #{Solution.part1}"
IO.puts "Total score with assumed strategies: #{Solution.part2}"
