require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req.cookies.select { |cookie| cookie.name == "_rails_lite_app" }.first
      @hash_cookie = cookie.nil? ? {} : JSON.parse(cookie.value)
    end

    def [](key)
      @hash_cookie[key]
    end

    def []=(key, val)
      @hash_cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = WEBrick::Cookie.new("_rails_lite_app", @hash_cookie.to_json)
      res.cookies << cookie
    end
  end
end
