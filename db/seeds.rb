# frozen_string_literal: true

CSV.foreach(Rails.root.join('./language-codes.csv'), headers: true) do |row|
  LanguageCode.find_or_create_by!(
    code: row['code'],
    country: row['country']
  )
end
