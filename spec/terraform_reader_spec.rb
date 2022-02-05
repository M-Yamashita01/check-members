# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TerraformReader do
  describe '#usernames' do
    it 'get members list' do
      terraform_directory_path = File.expand_path("#{__dir__}/fixtures")
      terraform_reader = TerraformReader.new(terraform_directory_path: terraform_directory_path)
      usernames = terraform_reader.usernames
      expect(usernames.size).to eq(7)
    end
  end
end
