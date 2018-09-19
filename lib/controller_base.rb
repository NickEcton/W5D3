require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params)
    @req = req
    @res = res
    @already_built_response = false
    test = "321"
    @params = params.merge(req.params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if @already_built_response
      raise "Double render"
    end
    @res['Location'] = url
    @res.status = 302
    session.store_session(@res)
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type = "text/html")
    if @already_built_response
      raise "Double render"
    end
    @res['Content-Type'] = content_type
    @res.body = [content]
    session.store_session(@res)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = "views/#{self.class.name.underscore}/#{template_name}.html.erb"
    render_content(ERB.new(File.read(path)).result(binding))
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

