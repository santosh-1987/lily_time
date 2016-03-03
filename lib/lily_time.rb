require "lily_time/version"
require "restclient"
require "pry"
require "json"

module LilyTime
  class Scanner
    URL = "http://localhost:12060/repository/scan"
    DATA = { :recordFilter => { "@class" => "org.lilyproject.repository.api.filter.RecordTypeFilter",:recordType => "{my.demo}product"},:caching => 10 }
    attr_accessor :scanner
    def initialize(args={})
      DATA["recordType"] = args[:recordType] if args[:recordType].present?
      puts  DATA
      rest_response = RestClient.post( URL, DATA.to_json,:content_type => :json)
      @scanner = rest_response.code == 201 ? rest_response.raw_headers["location"] : nil
    end

    def scan_records
      if @scanner.empty?
        puts "Scanner is Empty, Try Again"
      else
        status_code = 200
        until status_code != 200
          response = fetch_scanner
          status_code = response.code
          if status_code != 200
            puts "Triggering DELETE"
            response = RestClient.delete(@scanner.first)
            puts response.code
          else
            result = JSON.parse(response.body)
            result_set = result["results"]
            puts  result_set
          end
        end
      end
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
