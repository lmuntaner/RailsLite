require 'byebug'
require_relative '../phase6/router'

module Phase7
  
  class Route < Phase6::Route
    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res, router)
      match_data = pattern.match(req.path)
      params = {}
      match_data.names.each_with_index do |key, index|
        params[key.to_sym] = match_data.captures[index]
      end
      controller_class.new(req, res, params, router).invoke_action(action_name)
    end
  end
  
  class Router < Phase6::Router
    # either throw 404 or call run on a matched route
    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name)
    end
    
    def run(req, res)
      route = match(req)
      return res.status = 404 if route.nil?
      route.run(req, res, self)
    end
  end
end

