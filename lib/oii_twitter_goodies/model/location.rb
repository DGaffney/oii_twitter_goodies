require 'open-uri'
class Location
  include MongoMapper::Document
  key :term, String
  key :coordinate_data_yahoo, String
  key :coordinate_data_google, Hash
  
  def self.grab(term)
    term = term || ""
    if (loc = Location.first(:term => term.downcase))
      return loc
    else
      loc = Location.new(:term => term.downcase)
      loc.coordinate_data_yahoo = Location.coordinate_data_yahoo(term)
      loc.coordinate_data_google = Location.coordinate_data_google(term)
      loc.save!
      return loc
    end
  end
  
  def self.coordinate_data_yahoo(term)
    return Yahoo.locate(term)
  end
  
  def self.coordinate_data_google(term)
    return Google.locate(term).to_hash
  end
  
  def google
    return self.coordinate_data_google if self.coordinate_data_google.nil?
    if self.coordinate_data_google["success"] && self.coordinate_data_google["success"] == true
      return {:lat => self.coordinate_data_google["lat"], :lng => self.coordinate_data_google["lng"]}
    else
      return nil
    end
  end

  def yahoo
    return self.coordinate_data_yahoo if self.coordinate_data_yahoo.nil? || self.coordinate_data_yahoo.empty?
    lat = self.coordinate_data_yahoo.split(",").first.to_f
    lng = self.coordinate_data_yahoo.split(",").last.to_f
    return {:lat => lat, :lng => lng}
  end
end