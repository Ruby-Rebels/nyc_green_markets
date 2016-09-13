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
      create_markets(markets_array)
    end

    def self.where(search_term)
      key = search_term.keys.first.to_s
      value = search_term.values.first
      markets_array = Unirest.get("https://data.cityofnewyork.us/resource/cw3p-q2v6.json?#{key}=#{value}").body
      create_markets(markets_array)
    end

    def self.find_by(search_term)
      key = search_term.keys.first.to_s
      value = search_term.values.first
      market = Unirest.get("https://data.cityofnewyork.us/resource/cw3p-q2v6.json?#{key}=#{value}").body.first
      GreenMarket.new(market)
    end

    private_class_method :create_markets

    def self.create_markets(markets_array)
      markets_array.map { |market| GreenMarket.new(market)}
    end
  end
end
