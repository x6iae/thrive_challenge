
# this file serves as an entrypoint into the system
require_relative 'data_models/user'
require_relative 'data_models/company'
require_relative 'data_models/schemas/company_schema'
require_relative 'data_models/schemas/user_schema'
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

require "json-schema"

processed_company_token_details = {}
def open_and_read_file(file_path)
  begin
    file = File.read(file_path)
    JSON.parse(file)
  rescue => e
    error_msg = "File at #{file_path} can not be found or unable to open"
    log_error_and_exit(error_msg)
  end
end

def log_error_and_exit(error_msg, metadata: [])
  puts "#{metadata.join(', ')} - #{error_msg}"
  exit
end

companies_data = open_and_read_file('companies.json')
companies_validation_result = JSON::Validator.fully_validate(CompanySchema::SCHEMA, companies_data, list: true)
log_error_and_exit(companies_validation_result, metadata: ['companies.json']) unless companies_validation_result.empty?

companies_data.each do |company_hash|
  company = Company.new(company_hash)
  processed_company_token_details[company.id.to_s] = { company: company, users: [] }
end

users_data = open_and_read_file('users.json')
users_validation_result = JSON::Validator.fully_validate(UserSchema::SCHEMA, users_data, list: true)
log_error_and_exit(users_validation_result, metadata: ['users.json']) unless users_validation_result.empty?

users_data.each do |user_hash|
  company_id = user_hash['company_id']&.to_s
  company_info = processed_company_token_details[company_id]

  # if there is no associated company for this user, skip them.
  next unless company_info

  user = User.new(raw_hash: user_hash, company: company_info[:company])
  company_info[:users] << user
end

TxtOutputService.perform(processed_company_token_details)
