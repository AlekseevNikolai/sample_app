class Cock < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  def emoji
    if self.size.to_i >= 25
      "\u{1F346}"
    elsif self.size.to_i >= 20
      "\u{1F635}"
    elsif self.size.to_i >= 15
      "\u{1F631}"
    elsif self.size.to_i >= 10
      "\u{1F60D}"
    elsif self.size.to_i >= 5
      "\u{1F60F}"
    else
      "\u{1F484}"
    end
  end
end
