# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hcl2hashConversion do
  describe '#convert_to_hash' do
    context 'when terraform file is converted into json correctly' do
      before do
        hcl2json_outputs =
          "{
            \"resource\": {
              \"github_membership\": {
                \"membership_for_some_user1\": [
                  {
                    \"role\": \"member\",
                    \"username\": \"Membership1\"
                  }
                ],
                \"membership_for_some_user2\": [
                  {
                    \"role\": \"member\",
                    \"username\": \"Membership2\"
                  }
                ],
                \"membership_for_some_user3\": [
                  {
                    \"role\": \"member\",
                    \"username\": \"Membership3\"
                  }
                ],
                \"membership_for_some_user4\": [
                  {
                    \"role\": \"member\",
                    \"username\": \"Membership3\"
                  }
                ],
                \"membership_for_some_user5\": [
                  {
                    \"role\": \"member\",
                    \"username\": \"Membership1\"
                  }
                ],
                \"membership_for_some_user6\": [
                  {
                    \"role\": \"member\",
                    \"username\": \"Membership4\"
                  }
                ],
                \"membership_for_some_user7\": [
                  {
                    \"role\": \"member\",
                    \"username\": \"Membership3\"
                  }
                ]
              }
            }
          }"
        allow(Open3).to receive(:capture3).and_return([hcl2json_outputs, '', ''])
      end

      it 'get json format of terraform file' do
        expected_json = {
          'resource' => {
            'github_membership' => {
              'membership_for_some_user1' => [
                {
                  'role' => 'member',
                  'username' => 'Membership1'
                }
              ],
              'membership_for_some_user2' => [
                {
                  'role' => 'member',
                  'username' => 'Membership2'
                }
              ],
              'membership_for_some_user3' => [
                {
                  'role' => 'member',
                  'username' => 'Membership3'
                }
              ],
              'membership_for_some_user4' => [
                {
                  'role' => 'member',
                  'username' => 'Membership3'
                }
              ],
              'membership_for_some_user5' => [
                {
                  'role' => 'member',
                  'username' => 'Membership1'
                }
              ],
              'membership_for_some_user6' => [
                {
                  'role' => 'member',
                  'username' => 'Membership4'
                }
              ],
              'membership_for_some_user7' => [
                {
                  'role' => 'member',
                  'username' => 'Membership3'
                }
              ]
            }
          }
        }

        actual_json = Hcl2hashConversion.convert_to_hash(terraform_file_path: "#{__dir__}/fixtures/membership.tf")
        expect(actual_json).to eq(expected_json)
      end
    end

    context 'when Open3.capture3 returns error outputs' do
      before do
        allow(Open3).to receive(:capture3).and_return(['', 'error', ''])
      end

      it 'raise standard exception' do
        expect { Hcl2hashConversion.convert_to_hash(terraform_file_path: "#{__dir__}/fixtures/membership.tf") }
          .to raise_error(RuntimeError, 'error')
      end
    end
  end
end
