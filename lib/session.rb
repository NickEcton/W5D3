require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @session = JSON.parse(req.cookies["_rails_lite_app"] || "{}")
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie("_rails_lite_app", JSON.generate(@session))
  end
end
