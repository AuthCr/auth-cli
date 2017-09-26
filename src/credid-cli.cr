require "./credid-cli/*"
require "option_parser"
require "credid-api"

ip = "127.0.0.1"
port = 8999_u16
username = "root"
password = "toor"
ssl = false

OptionParser.parse! do |parser|
  parser.banner = "Usage: auth-cli <auth options> [path-to-check]"
  parser.on("-p=PORT", "--port=PORT", "Specify the port to bind") { |v| port = UInt16.new v }
  parser.on("-i=IP", "--ip=IP", "Specify the network interface") { |v| ip = v }
  parser.on("-u=NAME", "--username=NAME", "Specify the login") { |v| username = v }
  parser.on("-p=PASS", "--password=PASS", "Specify the password") { |v| password = v }
  parser.on("-s", "--secure", "Connect using ssl") { ssl = true }
  parser.on("-h", "--help", "Show this help") { puts parser; exit }
end

api = Credid::Api.new ip, port, username, password, ssl, !!ENV["DEBUG"]? || false
api.auth!
puts "Credidentication: #{api.success?}"
if api.success? && ARGV[0]?
  api.has_access_to? ARGV[0]?
  puts "Has access to #{ARGV[0]?}: #{api.success?}"
end
api.close
