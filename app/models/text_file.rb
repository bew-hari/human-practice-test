class TextFile < ActiveRecord::Base


	def self.save(upload)
    name = upload['file'].original_filename
    directory = "public/txt"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['file'].read) }
  end

end
