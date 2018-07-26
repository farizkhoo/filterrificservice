class Service < ApplicationRecord
	belongs_to :country

	filterrific(
   default_filter_params: { sorted_by: 'created_at_desc' },
   available_filters: [
     :sorted_by,
     :search_query,
     :with_country_id,
     :with_created_at_gte
   ]
 )
 # define ActiveRecord scopes for
 # :search_query, :sorted_by, :with_country_id, and :with_created_at_gte
 	scope :search_query, lambda { |query|
    # Filters services whose name matches the query
 # Searches the students table on the 'first_name' and 'last_name' columns.
  # Matches using LIKE, automatically appends '%' to each term.
  # LIKE is case INsensitive with MySQL, however it is case
  # sensitive with PostGreSQL. To make it work in both worlds,
  # we downcase everything.
  return nil  if query.blank?

  # condition query, parse into individual keywords
  terms = query.downcase.split(/\s+/)

  # replace "*" with "%" for wildcard searches,
  # append '%', remove duplicate '%'s
  terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }
  # configure number of OR conditions for provision
  # of interpolation arguments. Adjust this if you
  # change the number of OR conditions.

  # num_or_conds = 2
  # where(
  #   terms.map { |term|
  #     "(LOWER(services.name) LIKE ? OR LOWER(students.last_name) LIKE ?)"
  #   }.join(' AND '),
  #   *terms.map { |e| [e] * num_or_conds }.flatten
  # )

  where("LOWER(services.name) LIKE ?", terms)
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("services.created_at #{ direction }")
    when /^name_/
      order("LOWER(services.name) #{ direction }")
    when /^price_/
      order("services.price #{ direction }")
    when /^price_/
      order("services.cost #{ direction }")
    when /^country_name_/
      order("LOWER(countries.name) #{ direction }").includes(:country).references(:country)
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  scope :with_country_id, lambda { |country_ids|
  	where(:country_id => [*country_ids])

  }
  scope :with_created_at_gte, lambda { |ref_date|
  	where('services.created_at >= ?', ref_date)

  }

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Price (lowest -> highest)', 'price_asc'],
      ['Price (highest -> lowest)', 'price_desc'],
	  ['Cost (lowest -> highest)', 'cost_asc'],
	  ['Cost (highest -> lowest)', 'cost_desc'],
      ['Country (a-z)', 'country_name_asc'],
      ['Registration date (newest first)', 'created_at_desc'],
      ['Registration date (oldest first)', 'created_at_asc'],

    ]
  end

  def decorated_created_at
    created_at.to_date.to_s(:long)
  end
end
