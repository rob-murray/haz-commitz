
module HazCommitz
    class GithubRepository
        attr_reader :owner, :name
        attr_accessor :latest_commit, :rating

        def initialize(owner, repo_name)
            @owner = owner
            @name = repo_name

            @rating = 0
        end

        def path
            "#{owner}/#{name}"
        end

        def rate_with(rating_strategy)
            @rating = rating_strategy.rate(self)
        end

        def self.new_from_path(repo_path)
            if repo_path.nil? || repo_path.split('/').size != 2
                nil
            else
                GithubRepository.new(*repo_path.split('/'))
            end
        end

    end
end