class Commit
  attr_reader :sha, :author_name, :date, :message

  def initialize(sha, author_name, date, message = '')
    @sha = sha
    @author_name = author_name
    @date = date
    @message = message
  end
end
