#    add_column :users, :name, :string
# add_column :users, :internal_notes, :text
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true, presence: true

  # TODO: user permit :avatar in controller..
  has_one_attached :avatar

  def to_s
    email
  end
end
