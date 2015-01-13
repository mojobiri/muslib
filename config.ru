# Tu run app just type rackup
# config.ru
require "./app/muslink.rb"
require "thin"
run Muslink