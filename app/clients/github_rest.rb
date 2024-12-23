require_relative 'github_base'

module Clients
  class GithubRest < Clients::GithubBase
    def fetch_issues(state: 'open')
      fetch_paginated('/issues', { state: state })
    end
  end
end
