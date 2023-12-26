class SLCSP
  def initialize(csv_data, plan_processor, zip_processor)
    @original_csv_data = csv_data
    @final_csv_data = create_final_slcsp_data(plan_processor, zip_processor)
  end

  def create_new_slcsp_csv(file_name)
    csv_processer = CSVProcessor.new(file_name)
    csv_processer.create_csv(@final_csv_data)
  end

  def print_final_csv_data
    @final_csv_data.each do |row|
      puts row
    end
  end

  private


  def create_final_slcsp_data(plan_processor, zip_processor)
    final_csv_data = ["zipcode,rate"]

    @original_csv_data.each do |row|
      zipcode = row[:zipcode]

      rate_area = zip_processor.get_rate_area(zipcode) 
      plans = plan_processor.get_plans_by_rate_area(rate_area)

      slcsp_value = get_slcsp_rate(plans)
      formatted_slcsp_value = get_formatted_slcsp_value(slcsp_value)

      final_csv_data << "#{zipcode.to_s},#{formatted_slcsp_value}"
    end

    final_csv_data
  end

  def get_slcsp_rate(plans)
    if plans == nil || plans.size == 0
      return nil
    end

    final_silver_plans_rates = get_final_silver_plans_rates(plans)

    if final_silver_plans_rates.size <= 1
      return nil
    end

    # Since we want the second lowest cost silver plan, we take the second rate in the array.
    return final_silver_plans_rates[1]
  end

  def get_final_silver_plans_rates(plans)
    # Filter plans to just silver plans.
    silver_plans = get_only_silver_plans(plans) 
    # Sort silver plans by rate.
    sorted_silver_plans = get_sorted_silver_plans(silver_plans)
    # Extract just sorted silver plans rates.
    sorted_silver_plans_rates = get_sorted_silver_plans_rates(sorted_silver_plans)
    # Remove duplicates.
    sorted_silver_plans_rates.uniq
  end

  def get_only_silver_plans(plans) 
    plans.select do |plan| 
      plan.metal_level == "Silver"
    end
  end

  def get_sorted_silver_plans(silver_plans)
    silver_plans.sort_by do |plan| 
      plan.rate
    end
  end

  def get_sorted_silver_plans_rates(sorted_silver_plans)
    sorted_silver_plans.map do |plan| 
      plan.rate
    end
  end

  def get_formatted_slcsp_value(slcsp_value)
    if slcsp_value != nil
      # This takes the "slcsp_value" as a float & turns it as a string with 2 decimal places, to meet the requirements.
      # EX:  245.2 turns into "245.20"
      return "#{'%.2f' % slcsp_value}"
    else
      return ""  
    end
  end
end