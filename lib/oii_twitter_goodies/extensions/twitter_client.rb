module Twitter
  class Client
    def get(path, params={})
      lookup = TwitterAPICall.first(:url => path.to_s, :params => params)
      if lookup
        return lookup.data
      else
        response = request(:get, path, params)
        if response[:status] && response[:status] == 200
          lookup = TwitterAPICall.new(:url => path.to_s, :params => params, :data => response[:body])
          lookup.save!
        end
        return response
      end
    end
  end
end
