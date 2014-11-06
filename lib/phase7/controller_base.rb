require_relative '../phase6/controller_base'

module URLHelper
  def url_helpers(router)
    router.routes.each do |route|
      method_name = get_method_name(route.pattern)
      path_name = get_path_name(route.pattern)
      self.class.send(:define_method, method_name) do |*ids|
        path_name_with_args(path_name, *ids)
      end
    end
  end
  
  def get_method_name(pattern)
    # keys = pattern.names
    array_path = patter_to_a(pattern)
    array_path.select! { |path| (path =~ /\w+_id$/).nil? }
    # keys.count.times do |i|
    #   array_path[i] = array_path[i].singularize
    # end
    "#{array_path.join('_')}_url"
  end
  
  def get_path_name(pattern)
    array_path = patter_to_a(pattern)
    "/#{array_path.join('/')}"
  end
  
  def path_name_with_args(path_name, *ids)
    array_path = path_name.split('/').reject(&:empty?)
    i = 0
    array_path.map! do |path|
      if (path =~ /\w+_id$/).nil?
        path
      else
        i += 1
        ids[(i - 1)]
      end  
    end
    "/#{array_path.join('/')}"
  end
  
  def patter_to_a(pattern)
    str_path = pattern.source
    str_path.scan(/\w{2,}/)
  end
end

module Phase7
  class ControllerBase < Phase6::ControllerBase
    include URLHelper
    
    def initialize(req, res, route_params = {}, router)
      super(req, res, route_params)
      self.url_helpers(router)
    end
    
  end
end