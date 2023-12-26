class ZipProcessor
  def initialize 
    @zips = []
  end

  def create_zips(file_name)
    csv_content = get_csv_content(file_name)

    csv_content.each do |row|
      zip = create_single_zip(row) 

      @zips << zip
    end  
  end

  def get_rate_area(zipcode) 
    # Get all zips that match the "zipcode" passed in.
    zip_list = get_zip_list(zipcode)

    # Return nil, if there is nothing in the zip_list.
    if zip_list == nil || zip_list.size == 0
      return nil
    elsif zip_list.size > 1
      #In case there are multiple rate areas found, see if they all have same state & rate area.
      matches = look_for_rate_area_matches(zip_list)

      #Return nil, if not all rate areas matched.
      if matches.size > 0
         return nil
      end
    end

    #Return the first zip as a new StateRateArea object.
    create_state_rate_area(zip_list)
  end

  private 

  def get_csv_content(file_name)
    csv_processer = CSVProcessor.new(file_name)
    csv_processer.open_csv
  end

  def create_single_zip(row)
    zip = Zip.new()	

    zip.zipcode = row[:zipcode]
    zip.state = row[:state]
    zip.county_code = row[:county_code]
    zip.name = row[:name]
    zip.rate_area = row[:rate_area]

    zip
  end

  def get_zip_list(zipcode)
    @zips.select do |zip| 
      zip.zipcode == zipcode
    end
  end

  def look_for_rate_area_matches(zip_list)
    state = zip_list[0].state
    rate = zip_list[0].rate_area

    zip_list.reject do |zip| 
      zip.state == state && zip.rate_area == rate
    end
  end

  def create_state_rate_area(zip_list)
    state_rate_area = StateRateArea.new()

    state_rate_area.state = zip_list[0].state
    state_rate_area.rate_area = zip_list[0].rate_area

    state_rate_area
  end
end