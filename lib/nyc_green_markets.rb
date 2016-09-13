require "nyc_green_markets/version"
require 'unirest'

module NycGreenMarkets
  class GreenMarket
    attr_reader :name, :address, :city, :zip

    def initialize(market)
      @name = market['facilityname']
      @address = market['facilitystreetname']
      @city = market['facilitycity']
      @zip = market['facilityzipcode']
    end

    def self.all
      markets_array = Unirest.get('https://data.cityofnewyork.us/resource/cw3p-q2v6.json').body
      markets = []
      markets_array.each do |market|
        markets << GreenMarket.new(market)
      end
      markets
    end
  end
end
