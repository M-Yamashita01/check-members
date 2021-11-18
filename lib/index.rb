require 'octokit'

access_token = ENV['INPUT_GITHUB_TOKEN']

begin
  client = Octokit::Client.new(access_token: access_token)
  organization = client.org('my-organization-sandbox')
  org_plan = organization[:plan]
  filled_seats = org_plan['filled_seats']
  seats = org_plan['seats']

  puts "::set-output name=filled_seats::#{filled_seats}"
  puts "::set-output name=seats::#{seats}"
rescue => e
  puts '[ERROR] This actions is finished with error.'
  puts e.backtrace
end
