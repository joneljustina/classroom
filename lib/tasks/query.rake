# frozen_string_literal: true
require 'json'

desc "Run a GraphQL Query against the classroom API"
task query: :environment do
  ARGV.each { |a| task a.to_sym do ; end }

  QUERY = ARGV[1]
  variables = if ARGV[2]
    eval(ARGV[2])
  else
    {}
  end

  current_user = User.first

  parse_t1 = Time.now
  PARSED_QUERY = GitHubClassroom::ClassroomClient.parse(QUERY)
  parse_t2 = Time.now
  parse_delta = parse_t2 - parse_t1

  query_t1 = Time.now
  response = GitHubClassroom::ClassroomClient.query(PARSED_QUERY, variables: variables, context: { current_user: current_user })
  query_t2 = Time.now
  query_delta = query_t2 - query_t1

  puts "Response:"
  puts JSON.pretty_generate(response.data.to_h)

  puts

  puts "Parse time: #{parse_delta}"
  puts "Query time: #{query_delta}"
end