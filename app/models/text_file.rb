class TextFile < ActiveRecord::Base
  attr_accessor :filename, :flash_error

	def save(upload)
    if upload.nil?
      self.flash_error = 'No file selected.'
      return nil
    end

		uploaded_file = upload['file']

		# check for file validity
    if uploaded_file.content_type != 'text/plain'   # not plain text
      self.flash_error = 'File upload failed. Only plain text allowed.'
      return nil
    elsif uploaded_file.size > 4.megabytes          # file exceeds size limit
      self.flash_error = 'File upload failed. Maximum file size is 4 MB.'
      return nil
    end


   	# file is good to go
    name = 'temp_' + Time.now.strftime('%Y%m%d%H%M%S%N')
    directory = "tmp/txt"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(uploaded_file.read) }

    # return file name if save success
    name
  end

end
