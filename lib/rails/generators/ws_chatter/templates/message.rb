class <%= messages_model %> < ActiveRecord::Base
  belongs_to :sender, class_name: "<%= model_name %>"
  belongs_to :recipient, class_name: "<%= model_name %>"

  validates :body, presence: true
end
