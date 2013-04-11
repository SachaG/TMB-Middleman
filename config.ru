# encoding: utf-8

require File.expand_path("../rack_try_static", __FILE__)

use Rack::Auth::Basic, "Protected Area" do |username, password|
  username == 'meteor' && password == 'book'
end

use ::Rack::TryStatic,
  :root => "build",
  :urls => ["/"],
  :try  => [".html", "index.html", "/index.html"]
 
run lambda { [404, {"Content-Type" => "text/plain"}, ["File not found!"]] }