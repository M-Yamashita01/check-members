# frozen_string_literal: true

require 'octokit'
require_relative 'logging'

class GithubApiRequest
  include Logging

  def initialize(access_token:)
    @client = Octokit::Client.new(access_token: access_token)
  end

  def seats(organization_name:)
    organization = @client.org(organization_name)
    org_plan = organization[:plan]
    filled_seats = org_plan[:filled_seats]
    max_seats = org_plan[:seats]

    {
      filled_seats: filled_seats,
      max_seats: max_seats
    }
  rescue StandardError => e
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))
    raise e
  end

  def exist_user?(username:)
    @client.user(username)
    @client.last_response.status.eql?(200)
  end
end
