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

    def self.where(search_term)
      key = search_term.keys.first.to_s
      value = search_term.values.first
      markets_array = Unirest.get("https://data.cityofnewyork.us/resource/cw3p-q2v6.json?#{key}=#{value}").body
      markets = []
      markets_array.each do |market|
        markets << GreenMarket.new(market)
      end
      markets
    end

    def self.find_by(search_term)
      key = search_term.keys.first.to_s
      value = search_term.values.first
      market = Unirest.get("https://data.cityofnewyork.us/resource/cw3p-q2v6.json?#{key}=#{value}").body.first
      GreenMarket.new(market)
    end
  end
end
