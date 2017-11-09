require 'sinatra'
require 'json'

module GameOfShutl
  class Server < Sinatra::Base
    post '/quotes' do
      quote = JSON.parse(params['quote'])
      vehicleType = quote['vehicle']
      products = quote['products']
      puts JSON.parse(twitter_result.body)[0]
      price = ((quote['pickup_postcode'].to_i(36) - quote['delivery_postcode'].to_i(36)) / 1000).abs
      if vehicleType.nil?
        vehicleType = sizeLimit(products)
      else
        vehicleType = priceLimit(price, vehicle)
      end
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

    def priceLimit(price, vehicleType)
      if (vehicleType != "bicycle" && vehicleType != "motorbike" &&
          vehicleType != "parcel_car" && vehicleType != "small_van" &&
          vehicleType != "large_van")
        return "Invalid vehicle"
      end

      if (price <= 500)
        return "bicycle"
      elseif (price <= 750)
        return "motorbike"
      elseif (price <= 1000)
        return "parcel_car"
      elseif (price <= 1500)
        return "small_van"
      else
        return "large_van"
      end
    end

    def sizeLimit(products)
      int weight = 0
      int volume = 0
      products.each { |product|
        int weight += product.weight
        int volume += product.width * product.length * product.height
      }
      if (weight <= 3 && volume <= (30 * 25 * 10))
        return "bicycle"
      elseif (weight <= 6 && volume <= (35 * 25 * 25))
        return "motorbike"
      elseif (weight <= 50 && volume <= (100 * 100 * 75))
        return "parcel_car"
      elseif (weight <= 400 && volume <= (133 * 133 * 133))
        return "small_van"
      else
        return "large_van"
      end
    end
  end
end
