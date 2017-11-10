require 'sinatra'
require 'json'

module GameOfShutl
  class Server < Sinatra::Base
    post '/quotes' do
      quote = JSON.parse(params['quote'])
      # Assuming APIVersion 0 uses vehicle and all other versions use vehicleId
      apiVersion = request.headers["apiVersion"]
      isVersion0 = apiVersion == 0
      vehicleType = quote['vehicle']
      products = quote['products']
      price = ((quote['pickup_postcode'].to_i(36) - quote['delivery_postcode'].to_i(36)) / 1000).abs
      if vehicleType.nil?
        vehicleType = sizeLimit(products, isVersion0)
      else
        vehicleType = priceLimit(price, vehicle, isVersion0)
      end
      if (vehicleType == "bicycle" || vehicleType == 1)
        price = price + price * 0.1
      elseif (vehicleType == "motorbike" || vehicleType == 2)
        price = price + price * 0.15
      elseif (vehicleType == "parcel_car" || vehicleType == 3)
        price = price + price * 0.2
      elseif (vehicleType == "small_van" || vehicleType == 4)
        price = price + price * 0.3
      elseif (vehicleType == "large_van" || vehicleType == 5)
        price = price + price * 0.4
      else
        price = 0
        puts "Invalid vehicle"
      end
      if (isVersion0)
      {
        quote: {
          pickup_postcode: quote['pickup_postcode'],
          delivery_postcode: quote['delivery_postcode'],
          price: price,
          vehicle: vehicleType
        }
      }.to_json
      else
        {
          quote: {
            pickup_postcode: quote['pickup_postcode'],
            delivery_postcode: quote['delivery_postcode'],
            price: price,
            vehicleId: vehicleType
          }
        }.to_json
      end
    end

    def priceLimit(price, vehicleType, isVersion0)
      if (isVersion0 && vehicleType != "bicycle" && vehicleType != "motorbike" &&
            vehicleType != "parcel_car" && vehicleType != "small_van" &&
            vehicleType != "large_van")
          return "Invalid vehicle"
      elseif (!isVersion0 && vehicleType != 1 && vehicleType != 2 &&
            vehicleType != 3 && vehicleType != 4 &&
            vehicleType != 5)
          return "Invalid vehicle"
      end
      if (price <= 500)
        if (isVersion0)
          return "bicycle"
        else
          return 1
        end
      elseif (price <= 750)
        if (isVersion0)
          return "motorbike"
        else
          return 2
        end
      elseif (price <= 1000)
        if (isVersion0)
          return "parcel_car"
        else
          return 3
        end
      elseif (price <= 1500)
        if (isVersion0)
          return "small_van"
        else
          return 4
        end
      else
        if (isVersion0)
          return "large_van"
        else
          return 5
        end
      end
    end

    def sizeLimit(products, isVersion0)
      int weight = 0
      int volume = 0
      products.each { |product|
        int weight += product.weight
        int volume += product.width * product.length * product.height
      }
      if (weight <= 3 && volume <= (30 * 25 * 10))
        if (isVersion0)
          return "bicycle"
        else
          return 1
        end
      elseif (weight <= 6 && volume <= (35 * 25 * 25))
        if (isVersion0)
          return "motorbike"
        else
          return 2
        end
      elseif (weight <= 50 && volume <= (100 * 100 * 75))
        if (isVersion0)
          return "parcel_car"
        else
          return 3
        end
      elseif (weight <= 400 && volume <= (133 * 133 * 133))
        if (isVersion0)
          return "small_van"
        else
          return 4
        end
      else
        if (isVersion0)
          return "large_van"
        else
          return 5
        end
      end
    end
  end
end
