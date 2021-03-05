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


def print_stats(scores)
  puts

  if $options.join?
    2.times.with_index{ |i|

      print_hands(i+1, $conf["hands"].values_at(i, i+2))
      print_score(merge_scores(scores[i], scores[i+2]))

      puts
    }

  else
    scores.each_with_index{ |score, id|
      print_hands(id, [$conf["hands"][id]])
      print_score(score)

      puts
    }
  end
end


def print_hands(id, hands)
  printf("%d.\t%s\n", id, hands.map{ |hand| hand.join(", ") }.join("\t"))
end


def print_score(score)
  score.each{ |phase, stats|
    print_phase(phase, stats[:win_rate], stats[:error])
  }
end


def print_phase(phase, win_rate, error)
  printf("  %s:\t%.2f +- %.4f\n", phase.capitalize, win_rate.round(2), error.round(4))
end


def merge_scores(score1, score2)
  score1.map{ |phase, stats|
    [phase, {
      :win_rate => stats[:win_rate] + score2[phase][:win_rate],
      :error => stats[:error] + score2[phase][:error]
    }]
  }.to_h
end