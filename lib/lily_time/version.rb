require 'logger'
module LilyTime
  VERSION = "1.0.Beta"
  $LOGGER = Logger.new('lily_time.log')
  $CSV = Logger.new("lily_id_#{Time.now.to_i}.txt")
end