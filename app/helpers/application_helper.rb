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

  def display_fee(fee)
    sprintf("%.2f", fee.to_f/100)
  end

  def tax_amounts_for(charge)
    total = 0
    charge.metadata.each do |k, v|
      total = total + v.to_i
    end
    return total
  end
end
