require "lily_time/version"
require "restclient"
require "pry"
require "json"

module LilyRecord
  class Updater
    def self.update_records(records)
      $LOGGER.info("Recieved Records with Count : #{records.count}, Starting Update.")
      records.each do |record|
        #record ={"id"=>"USER.00493a3b-5476-3215-82b8-499c647a01e4","type"=>{"name"=>"ns1$Asset", "version"=>1},"fields"=>{"ns1$top"=>true, "ns1$publisher"=>"Time Inc.", "ns1$created_at"=>"2013-12-17T15:21:11.000Z", "ns1$approved"=>true, "ns1$byline"=>"20121201550", "ns1$coverDate"=>"20121201", "ns1$docType"=>"Asset", "ns1$publication"=>"Golf Magazine", "ns1$cover_date"=>"2012-12-01T00:00:00.000Z", "ns1$title_code"=>"550", "ns1$resized_images"=>["http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/205/", "http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/100/", "http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/155x198/", "http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/246x344/", "http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/286x379/", "http://nycitappclav2.timeinc.com/covx/550_2012_12_01.jpg/12AB/resize/500/"]},"namespaces"=>{"spotlight.covx"=>"ns1"}}
        #url = "http://localhost:12060/repository/record/"+record["id"]
        url = "http://localhost:12060/repository/record/"+record["id"]
        key_array = record["fields"].keys
        mappings = Hash[ *key_array.collect { |v| [ v, convert_namespace(v) ] }.flatten ]
        fields = record["fields"].map {|k, v| [mappings[k], convert_image_url(mappings[k],v)] }.to_h
        json_to_save = {:rest_url=>url, :type=>"n$Asset", :fields=>fields, :namespaces=>{:"org.lilyproject.vtag"=>"vtag", :"spotlight.covx"=>"n"}}
        $LOGGER.info("#{json_to_save}")
        status = 0
        rtn = 0
        RestClient.send("put", url, json_to_save.to_json, :content_type => :json, :accept => :json){ |response, &block|
          response_json = saved_record_json(response)
          rtn = response_json
          status = $LOGGER.info("#{response_json}")
        }
      end
    end

    def saved_record_json(response)
      JSON.parse response
    end

    def convert_namespace(namespace)
      namespace.gsub("ns1$","n$")
    end

    def convert_image_url(key,value)
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