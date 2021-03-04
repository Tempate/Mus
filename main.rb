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


require 'bundler/setup'

require 'slop'
require 'json'

require_relative 'api/mus.rb'


$options = Slop.parse do |option|
  option.string '-c', '--conf', 'JSON file with the configuration'

  option.bool '-j', '--join', 'Join probabilities by pairs'
  option.bool '-v', '--verbose', 'Show all output'

  option.bool '-e', '--exclusive', 'When exclusive mode is on, the remaining 
                           cards in a hand can be the same as the 
                           specified ones'
end

unless $options[:conf]
    puts $options
    exit
end

$conf = JSON.parse(File.read($options[:conf]))

print_stats(play_games)
