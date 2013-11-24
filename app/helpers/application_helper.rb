module ApplicationHelper

  def countries
    [
      ['Canada', 'CA']
    ]
  end

  def ca_provinces
    [
      ['AB', 'AB'],
      ['BC', 'BC'],
      ['MB', 'MB'],
      ['NB', 'NB'],
      ['NL', 'NL'],
      ['NS', 'NS'],
      ['NT', 'NT'],
      ['NU', 'NU'],
      ['ON', 'ON'],
      ['PE', 'PE'],
      ['QC', 'QC'],
      ['SK', 'SK'],
      ['YT', 'YT']
    ]
  end

  def us_states
    [
      ['AK', 'AK'],
      ['AL', 'AL'],
      ['AR', 'AR'],
      ['AZ', 'AZ'],
      ['CA', 'CA'],
      ['CO', 'CO'],
      ['CT', 'CT'],
      ['DC', 'DC'],
      ['DE', 'DE'],
      ['FL', 'FL'],
      ['GA', 'GA'],
      ['HI', 'HI'],
      ['IA', 'IA'],
      ['ID', 'ID'],
      ['IL', 'IL'],
      ['IN', 'IN'],
      ['KS', 'KS'],
      ['KY', 'KY'],
      ['LA', 'LA'],
      ['MA', 'MA'],
      ['MD', 'MD'],
      ['ME', 'ME'],
      ['MI', 'MI'],
      ['MN', 'MN'],
      ['MO', 'MO'],
      ['MS', 'MS'],
      ['MT', 'MT'],
      ['NC', 'NC'],
      ['ND', 'ND'],
      ['NE', 'NE'],
      ['NH', 'NH'],
      ['NJ', 'NJ'],
      ['NM', 'NM'],
      ['NV', 'NV'],
      ['NY', 'NY'],
      ['OH', 'OH'],
      ['OK', 'OK'],
      ['OR', 'OR'],
      ['PA', 'PA'],
      ['RI', 'RI'],
      ['SC', 'SC'],
      ['SD', 'SD'],
      ['TN', 'TN'],
      ['TX', 'TX'],
      ['UT', 'UT'],
      ['VA', 'VA'],
      ['VT', 'VT'],
      ['WA', 'WA'],
      ['WI', 'WI'],
      ['WV', 'WV'],
      ['WY', 'WY']
    ]
  end

  def subs
   {
     '12_ca' => {
       'name' => 'The Journeyman',
       'desc' => '12 high quality condoms',
       'interval' => '2-months',
       'interval-words' => '2 Months',
       'amount' => '$12.99CAD',
       'tax' => '$0.79CAD',
       'total' => '$12.76CAD'
     },
     '24_ca' => {
       'name' => 'The Adventurer',
       'interval' => 'month',
       'amount' => '$12.99',
       'tax' => '$0.79'
     }
   }
  end

  def display_fee(fee)
    '$'+sprintf("%.2f", fee.to_f/100)
  end
end
