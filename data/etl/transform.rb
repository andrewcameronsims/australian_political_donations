require 'json'
require 'csv'
require 'set'

RAW_JSON_PATH = './raw/australian_political_donations.json'
JSON_HEADERS = [
  "Financial Year",
  "Donor",
  "Value",
  "Party Name",
  "Party Group",
  "Receipt Type",
  "Donor Category",
  "Link to AEC"
]

raw_file = File.read(RAW_JSON_PATH)
donations_json = JSON.parse(raw_file)
donations = donations_json['data']

def emit_donors_csv(donations)
  unique_donors = []

  donations.each do |donation|
    next if unique_donors.include?([donation[1], donation[-2]])

    unique_donors << [donation[1], donation[-2]]
  end

  CSV.open("./donors.csv", "wb") do |csv|
    csv << ["name", "category"]
    unique_donors.each do |donor|
      csv << donor
    end
  end
end

def emit_recipients_csv(donations)
  unique_recipients = []

  donations.each do |donation|
    next if unique_recipients.include?([donation[3], donation[4]])

    unique_recipients << [donation[3], donation[4]]
  end

  CSV.open("./recipients.csv", "wb") do |csv|
    csv << ["party_name", "party_group"]
    unique_recipients.each do |recipient|
      csv << recipient
    end
  end
end

def emit_donations_csv(donations)
  CSV.open("./donations.csv", "wb") do |csv|
    csv << ["donor", "recipient", "monetary_value", "financial_year", "receipt_type", "aec_id"]
    aec_ids = Set.new

    donations.each do |donation|
      aec_id = donation[-1][/\d+/]
      next if aec_ids.include?(aec_id)

      aec_ids.add(aec_id)
      csv << [donation[1], donation[3], donation[2].tr(',', ''), donation[0], donation[-3], aec_id]
    end
  end
end

emit_donors_csv(donations)
emit_recipients_csv(donations)
emit_donations_csv(donations)
