
module HazCommitz
  class RepoRater
    MIN = 0
    MAX = 10

    def rate(github_repo)
      fail NotImplementedError, 'This method should be implemented'
    end
  end
end
