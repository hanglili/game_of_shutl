require 'sinatra'
require 'json'

module GameOfShutl
  class Server < Sinatra::Base
    post '/quotes' do
      quote = JSON.parse(params['quote'])
      vehicleType = quote['vehicle']
      price = ((quote['pickup_postcode'].to_i(36) - quote['delivery_postcode'].to_i(36)) / 1000).abs
      if (vehicleType == "bicycle")
        price = price + price * 0.1
      elseif (vehicleType == "motorbike")
        price = price + price * 0.15
      elseif (vehicleType == "parcel_car")
        price = price + price * 0.2
      elseif (vehicleType == "small_van")
        price = price + price * 0.3
      elseif (vehicleType == "large_van")
        price = price + price * 0.4
      else
        price = 0
        puts "Invalid vehicle"
        vehicleType = "Invalid vehicle"
      end
      {
        quote: {
          pickup_postcode: quote['pickup_postcode'],
          delivery_postcode: quote['delivery_postcode'],
          price: price,
          vehicle: vehicleType
        }
      }.to_json
    end
  end
end
