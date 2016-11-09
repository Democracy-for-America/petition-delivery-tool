# Generate individualized CSVs for each petition delivery target contained in targets.csv

require 'wicked_pdf'
require 'liquid'
require 'csv'

states = {
  'AL' => 'Alabama',
  'AK' => 'Alaska',
  'AS' => 'American Samoa',
  'AZ' => 'Arizona',
  'AR' => 'Arkansas',
  'CA' => 'California',
  'CO' => 'Colorado',
  'CT' => 'Connecticut',
  'DE' => 'Delaware',
  'DC' => 'District of Columbia',
  'FL' => 'Florida',
  'GA' => 'Georgia',
  'GU' => 'Guam',
  'HI' => 'Hawaii',
  'ID' => 'Idaho',
  'IL' => 'Illinois',
  'IN' => 'Indiana',
  'IA' => 'Iowa',
  'KS' => 'Kansas',
  'KY' => 'Kentucky',
  'LA' => 'Louisiana',
  'ME' => 'Maine',
  'MD' => 'Maryland',
  'MA' => 'Massachusetts',
  'MI' => 'Michigan',
  'MN' => 'Minnesota',
  'MS' => 'Mississippi',
  'MO' => 'Missouri',
  'MT' => 'Montana',
  'NE' => 'Nebraska',
  'NV' => 'Nevada',
  'NH' => 'New Hampshire',
  'NJ' => 'New Jersey',
  'NM' => 'New Mexico',
  'NY' => 'New York',
  'NC' => 'North Carolina',
  'ND' => 'North Dakota',
  'OH' => 'Ohio',
  'OK' => 'Oklahoma',
  'OR' => 'Oregon',
  'PA' => 'Pennsylvania',
  'PR' => 'Puerto Rico',
  'RI' => 'Rhode Island',
  'SC' => 'South Carolina',
  'SD' => 'South Dakota',
  'TN' => 'Tennessee',
  'TX' => 'Texas',
  'UT' => 'Utah',
  'VT' => 'Vermont',
  'VI' => 'Virgin Islands',
  'VA' => 'Virginia',
  'WA' => 'Washington',
  'WV' => 'West Virginia',
  'WI' => 'Wisconsin',
  'WY' => 'Wyoming',
}

system 'mkdir', '-p', 'pdf'

WickedPdf.config = { exe_path: 'bin/wkhtmltopdf' }

coverletter = Liquid::Template.parse( File.open('coverletter.html', 'rb') { |f| f.read } )

CSV.foreach('targets.csv', headers: true) do |row|
  signatures = CSV.read("csv/#{ row['state'] }.csv", headers: true).map{ |row| row.to_hash }

  binding = {
    'title'           => row['title'],
    'long_title'      => row['long_title'],
    'first'           => row['first'],
    'last'            => row['last'],
    'official_full'   => row['official_full'],
    'nickname'        => row['nickname'],
    'signature_count' => signatures.length.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse,
    'state'           => states[row['state']],
    'signatures'      => signatures
  }

  pdf = WickedPdf.new.pdf_from_string( coverletter.render(binding), dpi: '72' )

  File.open("pdf/#{ row['filename'] }.pdf", 'wb') do |file|
    file << pdf
  end

  puts "#{ row['filename'] }.pdf"
end
