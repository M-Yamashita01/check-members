require 'octokit'

access_token = ENV['INPUT_GITHUB_TOKEN']

client = Octokit::Client.new(access_token: access_token)
organization = client.org('my-organization-sandbox')
org_plan = organization[:plan]
filled_seats = org_plan['filled_seats']
seats = org_plan['seats']

puts "::set-output name=filled_seats::#{filled_seats}"
puts "::set-output name=seats::#{seats}"