=begin
This file is part of Mus.

Mus is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

Mus is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mus.  If not, see <https://www.gnu.org/licenses/>.
=end


def generate_deck()
  # No distinction is made between A and 2 and 3 and K since they're
  # respectively, exactly the same for all practical purposes.
  ["A", "A", "4", "5", "6", "7", "J", "Q", "K", "K"] * 4
end


def remove_cards_from_deck(deck, cards)
  cards.each{ |card| 
    deck.delete_at(deck.index(card) || deck.length) 
  }
end


def deal_hands(deck, hands, hand_size)
  remove_cards_from_deck(deck, hands.flatten)

  hands.map.with_index{ |hand, index|
    # When exclusive mode is off and a user says a hand has a certain card
    # he implies the other cards in that hand are different from the specified card.
    deck_to_use = $options[:exclusive] ? deck : (deck - hand)
    missing_cards = pick_hand(deck_to_use, hand_size - hand.length)
    
    remove_cards_from_deck(deck, missing_cards)

    hand + missing_cards
  }
end


def pick_hand(deck, size)
  deck.sample(size)
end


def calc_score_grande(hand)
  # Use values that make a high-card's score unreachable with lower scores.
  # NOTE: We can't get away by only multiplying by 4 because we would need 
  # to value A as 1, and 5^6 < 4^7.
  grande_card_values = {
    "A" => 0, "4" => 1, "5" => 5, "6" => 25, "7" => 125, "J" => 625, "Q" => 3125, "K" => 15625
  }

  hand.sum{ |card| grande_card_values[card] }
end


def calc_score_pares(hand)
  # Use values so that the hand with the highest 
  # pair (or set) always wins.
  # For example: KK AA > QQ QQ
  pares_card_values = {
    "A" => 1, "4" => 2, "5" => 4, "6" => 8, "7" => 16, "J" => 32, "Q" => 64, "K" => 128
  }

  repetitions = hand.tally.reject{ |card, count| count == 1 }
 
  # Use a sufficiently large factor to avoid branching
  # The factor has to be enough so that the highest score with 
  # the preceeding, lower factor gets a lower score.
  factor = 128 ** ((repetitions.values.inject(:+) || 0) - 2)
  
  # Multiply by count / 2 to account for quads
  repetitions.sum{ |card, count| pares_card_values[card] * (count / 2) } * factor
end


def calc_score_juego(hand)
  juego_card_values = {
    "A" => 1, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "J" => 10, "Q" => 10, "K" => 10
  }

  value = hand.sum{ |card| juego_card_values[card] }

  if value == 31
    42
  elsif value == 32
    41
  else
    value
  end
end


def play(hands)
  scores = hands.map{ |hand|
    [
      calc_score_grande(hand),
      calc_score_pares(hand),
      calc_score_juego(hand)
    ]
  }.transpose

  # If no one has a pair, nobody wins pares
  pares_max = scores[1].max
  pares_winner = pares_max != 0 ? scores[1].index(pares_max) : -1

  {
    "grande" => scores[0].index(scores[0].max),
    "chica"  => scores[0].index(scores[0].min),
    "pares"  => pares_winner,
    "juego"  => scores[2].index(scores[2].max)
  }
end


def play_games()
  scores = 4.times.map{ {"grande" => 0.0, "chica" => 0.0, "pares" => 0.0, "juego" => 0.0} }

  $conf["number_of_games"].times {
    score = play_game

    score.each{ |phase, player|
      scores[player][phase] += 1 unless player == -1
    }
  }

  normalize(scores)
end


def play_game()
  hands = deal_hands(generate_deck, $conf["hands"], 4)
  score = play(hands)

  if $options.verbose?
    puts hands.to_s
    puts score.to_s
  end

  score
end


def normalize(scores)
  calc_std = ->(xs, mean, n) { Math.sqrt(xs * (1 - mean)**2 + (n - xs) * mean**2) / n }

  scores.map.with_index{ |player, index|
    player.map{ |phase, wins|
      mean = wins / $conf["number_of_games"]
      std = calc_std.call(wins, mean, $conf["number_of_games"])
      
      [phase, {:win_rate => mean, :error => 2 * std}]    
    }.to_h
  }
end
