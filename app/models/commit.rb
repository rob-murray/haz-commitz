class Commit
  include Virtus.value_object

  values do
    attribute :sha, String
    attribute :author_name, String
    attribute :date, Time
    attribute :message, String
  end

  class << self
    def build(sha, author_name, date, message)
      new(sha: sha,
        author_name: author_name,
        date: date,
        message: message
      )
    end
  end
end
