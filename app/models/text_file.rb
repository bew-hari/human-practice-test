class TextFile < ActiveRecord::Base
  require 'yomu'


  attr_accessor :filename, :flash_error

	def save(upload)
    if upload.nil?
      self.flash_error = 'No file selected.'
      return nil
    end

		uploaded_file = upload[:file]

		if uploaded_file.size > 4.megabytes          # file exceeds size limit
      self.flash_error = 'File size exceeds maximum limit of 4 MB.'
      return nil
    end


   	# file is good to go
    yomu = Yomu.new uploaded_file
    text = yomu.text

    name = 'temp_' + Time.now.strftime('%Y%m%d%H%M%S%N')
    directory = Rails.root.join('tmp')
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(text) }

    # return file name if save success
    name
  end

end
