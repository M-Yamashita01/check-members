# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TerraformReader do
  describe '#convert_to_json' do
    context 'when terraform file is converted into json correctly' do
      before do
        hcl2json_outputs =
          "{
            \"resource\": {
              \"github_membership\": {
                \"membership_for_some_user\": [
                  {
                    \"role\": \"member\",
                    \"username\": \"SomeUser\"
                  },
                  {
                    \"role\": \"member\",
                    \"username\": \"SomeUser1\"
                  },
                  {
                    \"role\": \"member\",
                    \"username\": \"SomeUser2\"
                  },
                  {
                    \"role\": \"member\",
                    \"username\": \"SomeUser\"
                  },
                  {
                    \"role\": \"member\",
                    \"username\": \"SomeUser3\"
                  },
                  {
                    \"role\": \"member\",
                    \"username\": \"SomeUser2\"
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
              'membership_for_some_user' => [
                {
                  'role' => 'member',
                  'username' => 'SomeUser'
                },
                {
                  'role' => 'member',
                  'username' => 'SomeUser1'
                },
                {
                  'role' => 'member',
                  'username' => 'SomeUser2'
                },
                {
                  'role' => 'member',
                  'username' => 'SomeUser'
                },
                {
                  'role' => 'member',
                  'username' => 'SomeUser3'
                },
                {
                  'role' => 'member',
                  'username' => 'SomeUser2'
                }
              ]
            }
          }
        }

        actual_json = Hcl2jsonConversion.convert_to_json(terraform_file_path: "#{__dir__}/fixtures/membership.tf")
        expect(actual_json).to eq(expected_json)
      end
    end

    context 'when Open3.capture3 returns error outputs' do
      before do
        allow(Open3).to receive(:capture3).and_return(['', 'error', ''])
      end

      it 'raise standard exception' do
        expect { Hcl2jsonConversion.convert_to_json(terraform_file_path: "#{__dir__}/fixtures/membership.tf") }
          .to raise_error(RuntimeError, 'error')
      end
    end
  end
end
