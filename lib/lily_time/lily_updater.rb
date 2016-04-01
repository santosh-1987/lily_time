require "lily_time/version"
require "restclient"
require "pry"
require "json"

module LilyRecord
  class Updater
    def self.update_records(records,attributes)
      start_time = Time.now
      $LOGGER.info("Recieved Records with Count : #{records.count}, Starting Update at #{start_time.to_s}.")
      records.each do |record|
        if attributes.nil?
          $LOGGER.info("Record : #{record}")
          # Create URL
          url = "http://localhost:12060/repository/record/"+record["id"]
          #Fetch Keys from Record
          key_array = record["fields"].keys
          #Key mappings to substitute original Keys
          mappings = Hash[ *key_array.collect { |v| [ v, convert_namespace(v) ] }.flatten ]
          # Map with mappings and create values
          fields = record["fields"].map {|k, v| [mappings[k], convert_image_url(mappings[k],v)] }.to_h
          #Build the Json to be sent
          json_to_save = {:rest_url=>url, :type=>"n$Asset", :fields=>fields, :namespaces=>{:"org.lilyproject.vtag"=>"vtag", :"spotlight.covx"=>"n"}}

          $LOGGER.info("JSON to Save : #{json_to_save}")
          status = 0
          rtn = 0
          modify_status = record["fields"]["ns1$resized_images"].any? {|word| word.include?("nycitappclav2.timeinc.com") } rescue false
          if modify_status
            RestClient.send("put", url, json_to_save.to_json, :content_type => :json, :accept => :json){ |response, &block|
              response_json = saved_record_json(response)
              rtn = response_json
              $LOGGER.info("Response Detail :")
              status = $LOGGER.info("#{response_json}")
            }
          else
            $LOGGER.info("Record Doesnot consist of Nycitappclav2 url")
          end
        else
          $CSV.info("#{record['id']}")
        end
      end
      $LOGGER.info("Completed Batch at Time #{Time.now.to_s} & Difference is : #{(Time.now-start_time).to_s}")
    end

    def self.saved_record_json(response)
      JSON.parse response
    end

    def self.convert_namespace(namespace)
      namespace.gsub("ns1$","n$")
    end

    def self.convert_image_url(key,value)
      if key == "n$resized_images"
        return value.map do |img_url|
          if img_url.include?("nycitappclav2.timeinc.com")
            img_url.gsub("nycitappclav2.timeinc.com","imagexaws.timeinc.com")
          else
            img_url
          end
        end
      else
        return value
      end
    end
  end
end

=begin
record ={"id"=>"USER.00493a3b-5476-3215-82b8-499c647a01e4","type"=>{"name"=>"ns1$Asset", "version"=>1},"fields"=>{"ns1$top"=>true, "ns1$publisher"=>"Time Inc.", "ns1$created_at"=>"2013-12-17T15:21:11.000Z", "ns1$approved"=>true, "ns1$byline"=>"20121201550", "ns1$coverDate"=>"20121201", "ns1$docType"=>"Asset", "ns1$publication"=>"Golf Magazine", "ns1$cover_date"=>"2012-12-01T00:00:00.000Z", "ns1$title_code"=>"550", "ns1$resized_images"=>["http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/205/", "http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/100/", "http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/155x198/", "http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/246x344/", "http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/286x379/", "http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/500/"]},"namespaces"=>{"spotlight.covx"=>"ns1"}}
}
=end