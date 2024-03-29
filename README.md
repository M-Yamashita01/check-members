# Check Members

This action runs on pull requests to count GitHub organization members and membership written in terraform files.

## Examples
![Example comment made by the action](./examples/images/example-github-pr-check.png)

## Environment variables

### `ACCESS_TOKEN`
Required. This token needs to have `read:org` scope to read organization information by octokit.

See https://docs.github.com/en/rest/reference/orgs#get-an-organization

### `TERRAFORM_JSON_FILE_PATH`
Required. The json file from running the command `terraform show --json | jq`.

### `ORGANIZATION_NAME`
Required. This organization name for which you want to count seats.

## Outputs
### `filled_seats`
Seats that membership used.
### `max_seats`
Max seats an organization can use.

### `members_in_terraform`
Total number of membership in the `github_membership` and `github_repository_collaborator` resources written in the terraform file.

### `non_existing_members`
Members which are in terraform do not exist in GitHub.

## Example usage
- Note: This action should be used with setup-terraform step. The terraform_wrapper flag in the setup-terraform step should be set to false.

```
on: [pull_request]

jobs:
  job:
    runs-on: ubuntu-latest
    name: A job to show seats
    steps:
      - uses: actions/checkout@v2

      - uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.3.9
          terraform_wrapper: false

      - name: Terraform init
        run: terraform init

      - name: Terraform plan
        run: terraform plan -out plan-binary

      - name: Terraform show --json
        run:  terraform show --json plan-binary | jq >> terraform-json.json

      - name: Set up ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 2.7

      - name: Count seats and members
        id: seats_members
        uses: M-Yamashita01/check-members@v0.9
        env:
          ACCESS_TOKEN: ${{ secrets.GITHUB_ADMIN_ACCESS_TOKEN }}
          TERRAFORM_JSON_FILE_PATH: '${{ github.workspace }}/terraform-json.json'
          ORGANIZATION_NAME: 'organization_name'

      - name: Post comments
        uses: actions/github-script@v5
        with:
          script: |
            var output = `Current seats in organization and members in terraform files.\n
              ・Seats that membership used:: ${{ steps.seats_members.outputs.filled_seats }}\n
              ・Max seats an organization can use: ${{ steps.seats_members.outputs.max_seats }}\n
              ・Total number of membership in terraform files: ${{ steps.seats_members.outputs.members_in_terraform }}\n\n
            `
            const numberOfSeatsInShortage = ${{ steps.seats_members.outputs.members_in_terraform }} - ${{ steps.seats_members.outputs.max_seats }}
            var additional_message = `There is no shortage of seats.\n`
            if (numberOfSeatsInShortage > 0) {
              additional_message = `There are ${numberOfSeatsInShortage} seats missing. Please add seats.\n`
            }

            var notify_non_existing_member_message = ``
            const non_existing_members = "${{ steps.seats_members.outputs.non_existing_members }}"
            if (non_existing_members.length > 0) {
              notify_non_existing_member_message = `Some members in terraform files do not exist. Please check the members.\n
              ・Non-existing members: ${non_existing_members}.\n\n
              `
            }

            output += additional_message
            output += notify_non_existing_member_message
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: output
            })
```
