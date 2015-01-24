class NewRepositoryForm
  extend ActiveModel::Naming

  include Virtus.model
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attribute :path, String

  validates :path, presence: true
  validates_format_of :path, with: /\//i

  def model_name
    'Repository'
  end

  def persisted?
    false
  end

  def name
    path.split('/').last
  end

  def owner
    path.split('/').first
  end
end
