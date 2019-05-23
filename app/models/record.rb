class Record < ApplicationRecord
  audited only: :updated_at

end

# == Schema Information
#
# Table name: records
#
#  id          :bigint           not null, primary key
#  external_id :string
#  json_data   :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
