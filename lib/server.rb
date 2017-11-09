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
      product = products[0]

      if (product.weight <= 3 && product.width <= 50 && product.height <= 50 &&
          product.length <= 50)
        return "bicycle"
      elseif (product.weight <= 6 && product.width <= 35 &&
              product.height <= 25 && product.length <= 25)
        return "motorbike"
      elseif (product.weight <= 50 && product.width <= 100 &&
              product.height <= 100 && product.length <= 75)
        return "parcel_car"
      elseif (product.weight <= 400 && product.width <= 133 &&
              product.height <= 133 && product.length <= 133)
        return "small_van"
      else
        return "large_van"
      end
    end
  end
end
