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
    array_path = pattern_to_a(pattern)
    path_array = create_method_name(array_path)
    "#{path_array.join('_')}_url"
  end
  
  def create_method_name(array_path)
    path_array = []
    array_path.each_with_index do |path, index|
      if not_path_id?(path)
        path_array << path
      else
        path_array[index - 1] = array_path[index - 1].singularize
        path_array << ""
      end
    end
    path_array.reject(&:empty?)
  end
  
  def get_path_name(pattern)
    array_path = pattern_to_a(pattern)
    "/#{array_path.join('/')}"
  end
  
  def path_name_with_args(path_name, *ids)
    array_path = path_name.split('/').reject(&:empty?)
    i = 0
    array_path.map! do |path|
      if not_path_id?(path)
        path
      else
        i += 1
        ids[(i - 1)]
      end  
    end
    "/#{array_path.join('/')}"
  end
  
  def not_path_id?(path_name)
    (path_name =~ /\w+_id$/).nil? && path_name != "id"
  end
  
  def pattern_to_a(pattern)
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