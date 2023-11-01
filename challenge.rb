
# this file serves as an entrypoint into the system
require_relative 'data_models/user'
require_relative 'data_models/company'
require_relative 'services/txt_output_service'
require 'json'

# steps:
# - create company hash_key storage (indexed by ids)
#   - each value is an hash having two keys (1 for company other for users)
#   - company is a Company instance, User is another hash
#     - user-hash has keys of first_names
#     - values are User instance
# - read in company file, populate company hash_key store
# - read in user file, immediately filter them to respective company in hash_key storage
#   - add methods on user for:
#     - 'has email sent': check company and user email booleans
#     - 'new token balance': user token plus company token (factor active status)
# - create output file (use a service that validates the structure of input json)
# - maybe add some tests?

# Questions:
# - are last names unique?
# - are emails unique otherwise?
# - are emails always in format of first_name.last_name

processed_company_token_details = {}

# todo: rescue file reading and json parsing
company_file = File.read('companies.json')
JSON.parse(company_file).each do |company_hash|
  company = Company.new(company_hash)

  # TODO: next unless company is valid
  processed_company_token_details[company.id.to_s] = { company: company, users: [] }
end

# todo: rescue file reading and json parsing
user_file = File.read('users.json')
JSON.parse(user_file).each do |user_hash|
  # todo: can I make things all accessible by symbols?
  company_id = user_hash['company_id']&.to_s
  company_info = processed_company_token_details[company_id]
  user = User.new(raw_hash: user_hash, company: company_info[:company])

  # TODO: next unless user is valid
  company_info[:users] << user
end

TxtOutputService.perform(processed_company_token_details)
