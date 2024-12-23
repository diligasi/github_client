module Clients
  class GithubGraphql < GithubBase
    def fetch_project_issues(project_id)
      query = <<~GRAPHQL
        query {
          node(id: "#{project_id}") {
            ... on Project {
              items {
                title
                sprintDate
                points
              }
            }
          }
        }
      GRAPHQL
      @http_client.post('/graphql', {}, { query: query })
    end
  end
end
