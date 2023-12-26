class CSVProcessor
	def initialize (file_name)
		@path = get_file_path(file_name)
	end

	def open_csv
    # We are passing in "converters: :all" as an argument to automatically convert the CSV data, into the right data type we want when the file is opened.
    # Also, we are passing "header_converters: :symbol" as an argument to make the CSV headers symbols instead of strings for more readability.
    CSV.open(@path, headers: true, converters: :all, header_converters: :symbol)
  end

  def create_csv(data) 
    CSV.open(@path, "w") do |csv|
      csv << data
    end
  end

  private

  def get_file_path(file_name)
		"./data/#{file_name}"
	end
end