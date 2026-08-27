# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :validatable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :recoverable
end
