class SadTable
  include Mongoid::Document

  field :field_name , type: Hash


  has_many :task
  has_many :patient
end
