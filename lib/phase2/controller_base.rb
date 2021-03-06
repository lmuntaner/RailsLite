module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @req = req
      @res = res
      @already_built_response = false
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      @already_built_response
    end

    # Set the response status code and header
    def redirect_to(url)
      @res.status= 302
      assert_not_already
      @res["location"] = url
    end
    
    def assert_not_already
      if already_built_response?
        raise "Error!!"
      else
        @already_built_response = true
      end
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, type)
      @res.content_type = type
      if already_built_response?
        raise "Error!!"
      else
        @already_built_response = true
      end
      @res.body = content
    end
  end
end
