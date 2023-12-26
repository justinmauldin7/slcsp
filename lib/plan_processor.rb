class PlanProcessor
  def initialize 
    @plans = []
  end

  def create_plans(file_name)
    csv_content = get_csv_content(file_name)

    csv_content.each do |row|
      plan = create_single_plan(row) 

      @plans << plan
    end  
  end

  def get_plans_by_rate_area(rate_area)
    if rate_area == nil
      return nil
    end

    return get_matching_plans_list(rate_area)
  end

  private 

  def get_csv_content(file_name)
    csv_processer = CSVProcessor.new(file_name)
    csv_processer.open_csv
  end

  def create_single_plan(row)
    plan = Plan.new()	

    plan.plan_id = row[:plan_id]
    plan.state = row[:state]
    plan.metal_level = row[:metal_level]
    plan.rate = row[:rate]
    plan.rate_area = row[:rate_area]

    plan
  end

  def get_matching_plans_list(rate_area)
	  @plans.select do |plan| 
      plan.rate_area == rate_area.rate_area && plan.state == rate_area.state
    end
  end
end