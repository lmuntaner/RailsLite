require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @req = req
      @params = route_params
      query = @req.query_string || ""
      body = @req.body || ""
      @params.merge!(parse_www_encoded_form(query))
      @params.merge!(parse_www_encoded_form(body))
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      result = {}
      URI::decode_www_form(www_encoded_form).each do |pair|
        keys = parse_key(pair.first)
        current_hash = {}
        keys[0..-2].each do |key|
          current_hash = result
          current_hash[key] ||= current_hash
        end
        result[keys[-1]] = pair.last
      end
      result
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
