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

require "rspec/autorun"

require_relative "../core/game.rb"


$options = {:exclusive => false}


describe "#generate_deck" do
  it "returns the initial deck" do
    deck = generate_deck.tally

    expect(deck.values.inject(:+)).to eq(40)
    
    ["4", "5", "6", "7", "J", "Q"].each{ |card|
      expect(deck[card]).to eq(4)
    }

    ["A", "K"].each{ |card|
      expect(deck[card]).to eq(8)
    }
  end
end


describe "#remove_cards_from_deck" do
  context "given a deck and a list of cards" do
    it "can add remove the first instance of the each listed card from the deck" do
      deck = generate_deck

      remove_cards_from_deck(deck, ["4"] * 3)
      expect(deck.tally["4"]).to eq(1)

      cards = ["6", "5", "7", "J"]

      remove_cards_from_deck(deck, cards)
      deck_count = deck.tally

      expect(deck_count.values.inject(:+)).to eq(33) and
      cards.each{ |card| expect(deck_count[card]).to eq(3) }

      remove_cards_from_deck(deck, ["A"] * 5)
      expect(deck.tally["A"]).to eq(3)
    end
  end
end


describe "#deal_hands" do
  context "given a deck and a list of hands (exclusive mode off)" do
    it "deals each of the hands n cards" do
      $options[:exclusive] = false

      10.times {
        deck = generate_deck
        hands = deal_hands(deck, [["A"]] + Array.new(9) { [] }, 4)
  
        expect(hands.flatten.length).to eq(40)
        expect(deck.length).to eq(0)

        expect(hands[0].tally["A"]).to eq(1)
        expect(hands[1..].flatten.tally["A"]).to eq(7)
      }
    end
  end

  context "given a deck and a list of hands (exclusive mode on)" do
    it "deals each of the hands n cards" do
      $options[:exclusive] = true

      deck = generate_deck
      hands = deal_hands(deck, [["A"]], 40)

      expect(hands.flatten.length).to eq(40)
      expect(deck.length).to eq(0)
      
      expect(hands[0].tally["A"]).to eq(8)
    end
  end
end


describe "#calc_score_grande" do
  context "given a hand" do
    it "calculates a score for grande and chica" do
      hands = [
        ["A", "A", "A", "A"],
        ["4", "4", "6", "6"],
        ["A", "4", "7", "7"],
        ["J", "J", "J", "J"],
        ["7", "J", "J", "Q"],
        ["K", "Q", "Q", "Q"],
        ["K", "K", "Q", "A"],
        ["K", "K", "Q", "4"],
        ["K", "K", "K", "A"]
      ]

      expect(hands.sort_by{ |hand| calc_score_grande(hand) } ).to eq(hands)
    end
  end
end


describe "#calc_score_pares" do
  context "given a hand" do
    it "calculates a score for pares" do
      hands = [
        ["A", "4", "7", "7"],
        ["7", "J", "J", "Q"],
        ["K", "K", "Q", "A"],
        ["K", "Q", "Q", "Q"],
        ["K", "K", "K", "A"],
        ["A", "A", "A", "A"],
        ["4", "4", "6", "6"],
        ["4", "4", "J", "J"],
        ["Q", "Q", "Q", "Q"],
        ["K", "K", "A", "A"]
      ]

      expect(hands.sort_by{ |hand| calc_score_pares(hand) } ).to eq(hands)
    end
  end
end


describe "#calc_score_juego" do
  context "given a hand" do
    it "calculates a score for juego" do
      hands = [
        ["A", "A", "A", "A"],
        ["A", "4", "7", "7"],
        ["4", "4", "6", "6"],
        ["Q", "Q", "7", "6"],
        ["J", "K", "7", "7"],
        ["Q", "5", "Q", "Q"],
        ["K", "K", "6", "J"],
        ["J", "J", "K", "7"],
        ["J", "Q", "K", "Q"],
        ["Q", "5", "J", "7"],
        ["7", "7", "7", "J"]
      ]

      expect(hands.sort_by{ |hand| calc_score_juego(hand) } ).to eq(hands)
    end
  end
end