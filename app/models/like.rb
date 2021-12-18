class Like < ApplicationRecord
    belongs_to :user
    belongs_to :post, class_name: "Cock"
    validates :user_id, presence: true
    validates :post_id, presence: true
end
