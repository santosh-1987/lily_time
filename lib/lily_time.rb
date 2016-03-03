require "lily_time/version"
require "restclient"
require "pry"
require "json"

module LilyTime
  class Scanner
    URL = "http://localhost:12060/repository/scan"
    DATA = { :recordFilter => { "@class" => "org.lilyproject.repository.api.filter.RecordTypeFilter",:recordType => "{my.demo}product"},:caching => 10 }
    attr_accessor :scanner,:error
    def initialize(args={})
      DATA[:recordFilter][:recordType] = args[:recordType] if args.key? :recordType
      @dynamic_url = args[:url] if args.key? :url
      RestClient.post(@dynamic_url || URL, DATA.to_json,:content_type => :json){|rest_response, request, result|
        if rest_response.code == 201
          @scanner = rest_response.raw_headers["location"]
        else
         @error = JSON.parse(result.body) rescue rest_response
        end
      }
    end

    def scan_records
      @records = Array.new
      @delete_response = nil
      if @scanner && !@scanner.empty?
        status_code = 200
        until status_code != 200
          response = fetch_scanner
          status_code = response.code
          if status_code != 200
            response = RestClient.delete(@scanner.first)
            @delete_response = response.code
          else
            result = JSON.parse(response.body)
            result_set = result["results"]
            @records << result_set
          end
        end
      else
        @error = @error.to_s + "Scanner is Empty, Try Again"
      end
      return {:records => @records.flatten,:scanner_deletion => @delete_response,:error => @error }
    end

    def self.run_program
      lily_scanner = LilyTime::Scanner.new
      lily_scanner.scan_records
    end

    private

    def fetch_scanner
      RestClient.get((@scanner.first)+("?batch=10"))
    end

  end

end
