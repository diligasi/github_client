module Services
  class FetchIssues
    def initialize(client)
      @client = client
    end

    def call(state: 'open')
      issues = @client.fetch_issues(state: state)
      issues.sort_by { |issue| issue[state == 'closed' ? 'closed_at' : 'created_at'] }
            .reverse.each do |issue|
        puts "#{issue['title']} - #{issue['state']} - Date: #{issue[state == 'closed' ? 'closed_at' : 'created_at']}"
      end
    end
  end
end
