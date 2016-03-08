require "lily_time/version"
require "lily_time/lily_updater"
require "restclient"
require "pry"
require "json"

module LilyTime
  class Scanner
    include LilyRecord
    URL = "http://localhost:12060/repository/scan"
    DATA = { :recordFilter => { "@class" => "org.lilyproject.repository.api.filter.RecordTypeFilter",:recordType => "{my.demo}product"},:caching => 10 }
    attr_accessor :scanner,:error
    def initialize(args={})
      $LOGGER.info("Program Started .")
      DATA[:recordFilter][:recordType] = args[:recordType] if args.key? :recordType
      @dynamic_url = args[:url] if args.key? :url
      RestClient.post(@dynamic_url || URL, DATA.to_json,:content_type => :json){|rest_response, request, result|
        if rest_response.code == 201
          @scanner = rest_response.raw_headers["location"]
          $LOGGER.info("Scanner URL : #{@scanner.first}")
        else
          @error = JSON.parse(result.body) rescue rest_response
        end
      }
    end

    def scan_records
      @records = Array.new
      @results = Array.new
      @delete_response = nil
      if @scanner && !@scanner.empty?
        status_code = 200
        count = 1 # Count to log number of times the scanner is executed.
        until status_code != 200
          # Fetch Records until last record is reached
          response = fetch_scanner(count)
          status_code = response.code rescue 500
          if status_code != 200
            $LOGGER.info("Triggering DELETE SCANNER Request")
            response = RestClient.delete(@scanner.first)
            @delete_response = response.code
            $LOGGER.info("Triggered DELETE Request with Response code #{@delete_response}")
          else
            count += 1
            result = JSON.parse(response.body)
            result_set = result["results"]
            @results << LilyRecord::Updater.update_records(result_set)
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

    def fetch_scanner(count)
      $LOGGER.info("Fetching Record for : #{@scanner.first} with count #{count}")
      begin
        RestClient.get((@scanner.first)+("?batch=1"))
      rescue => e
        $LOGGER.info("Error Fetching records from scanner: #{e.inspect} ")
      end
    end
  end

end
