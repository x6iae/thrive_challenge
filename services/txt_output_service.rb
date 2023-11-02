module TxtOutputService
  extend self

  OUTPUT_FILE_NAME = 'output.txt'

  require 'pry'

  def perform(processed_company_token_details)
    # first clear out the output file for a new write
    File.open(OUTPUT_FILE_NAME, 'w') {}

    # Companies should be ordered by company id.
    company_keys_sorted = processed_company_token_details.keys.sort

    company_keys_sorted.each do |key|
      write_company_user_data(processed_company_token_details[key])
    end
  end

  private
  def write_company_user_data(processed_company_data)
    company = processed_company_data[:company]
    users = processed_company_data[:users]

    # separate out users emailed from users not emailed
    users_emailed = []
    users_not_emailed = []
    users.each do |user|
      if user.can_get_token_top_up? && user.can_receive_email?
        users_emailed << user
      elsif user.can_get_token_top_up?
        # todo: question: do we want to include users with no top up in output?
        users_not_emailed << user
      end
    end

    # nothing to write if no user in company is receiving topup
    return if users_emailed.empty? && users_not_emailed.empty?

    total_topup = calculate_total_top_up(users)
    append_company_data_to_output_file(company)
    append_users_emailed_data_to_output_file(users_emailed)
    append_users_not_emailed_data_to_output_file(users_not_emailed)
    append_total_topups_for_company(company, total_topup)
  end

  def append_users_emailed_data_to_output_file(users)
    heading = "Users Emailed:\n"
    append_users_data_to_output_file(users: users, heading: heading)
  end

  def append_users_not_emailed_data_to_output_file(users)
    heading = "Users Not Emailed:\n"
    append_users_data_to_output_file(users: users, heading: heading)
  end

  def append_users_data_to_output_file(heading:, users:)
    write_new_line_to_output_file(heading)

    # Users should be ordered alphabetically by last name.
    users.sort_by(&:last_name).each{ |user| append_user_data_to_output_file(user) }
  end

  def append_company_data_to_output_file(company)
    company_data = <<~COMPANY_DATA
      \nCompany Id: #{company.id}
      Company Name: #{company.name}
    COMPANY_DATA
    write_new_line_to_output_file(company_data)
  end

  def append_user_data_to_output_file(user)
    # TODO: question: should there be a comma after previous token balance?
    user_data = <<~USER_DATA
      \t#{[user.last_name, user.first_name, user.email].join(', ')}
      \t\tPrevious Token Balance, #{user.tokens}
      \t\tNew Token Balance #{user.new_token_balance}
    USER_DATA
    write_new_line_to_output_file(user_data)
  end

  def append_total_topups_for_company(company, total_topup)
    topup_data = <<~TOPUP_DATA
      \tTotal amount of top ups for #{company.name}: #{total_topup}
    TOPUP_DATA
    write_new_line_to_output_file(topup_data)
  end

  def write_new_line_to_output_file(data)
    File.write(OUTPUT_FILE_NAME, data, mode: 'a')
  end

  # todo: parse to int for calculations
  def calculate_total_top_up(users)
    total_initial_tokens = users.sum(&:tokens)
    total_new_token_balance = users.sum(&:new_token_balance)
    total_new_token_balance - total_initial_tokens
  end
end
