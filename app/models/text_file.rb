class TextFile < ActiveRecord::Base


	def self.save(upload)
		uploaded_file = upload['file']

		# not a text file
    return nil if uploaded_file.content_type != 'text/plain'
   	
    name = 'temp_' + Time.now.strftime('%Y%m%d%H%M%S%N')
    directory = "public/txt"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(uploaded_file.read) }
    return name
  end

end
