# frozen_string_literal: true

require 'octokit'
require 'logger'

logger = Logger.new(STDOUT)
access_token = ENV['INPUT_GITHUB_TOKEN']

begin
  client = Octokit::Client.new(access_token: access_token)
  organization = client.org('my-organization-sandbox')
  logger.info("organization: #{organization.inspect}")
  org_plan = organization[:plan]
  filled_seats = org_plan[:filled_seats]
  seats = org_plan[:seats]
  logger.info("filled_seats:#{filled_seats}")
  logger.info("seats:#{seats}")

  puts "::set-output name=filled_seats::#{filled_seats}"
  puts "::set-output name=seats::#{seats}"
rescue => e
  logger.error('This actions is finished with error.')
  logger.error(e.class)
  logger.error(e.message)
  logger.error(e.backtrace.join("\n"))
end
