require "csv"
require "pry"

require "./lib/csv_processor.rb"
require "./lib/plan_processor.rb"
require "./lib/zip_processor.rb"

require "./lib/plan.rb"
require "./lib/zip.rb"
require "./lib/state_rate_area.rb"
require "./lib/slcsp.rb"


puts "-------Starting Program-------"

plan_processor = PlanProcessor.new()
plan_processor.create_plans("plans.csv")

zip_processor = ZipProcessor.new()
zip_processor.create_zips("zips.csv")

csv_processer = CSVProcessor.new("slcsp.csv")
original_slcsp_csv_data = csv_processer.open_csv

slcsp = SLCSP.new(original_slcsp_csv_data, plan_processor, zip_processor)
slcsp.create_new_slcsp_csv("updated_slcsp.csv")
puts "\nNew slcsp CSV file created"
puts "(You can find the new CSV in the 'data' folder)"

puts "\n*******Starts the printing of the new slcsp CSV data*******"
slcsp.print_final_csv_data
puts "*******Ends the printing of the new slcsp CSV data******* \n\n"

puts "-------Ending Program-------"