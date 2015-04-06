class UploadController < ApplicationController

	def index
		session[:file_content] = nil
	end

	def create
		filesave = TextFile.save(params[:upload])



		name = params[:upload][:file].original_filename
    directory = "public/images/upload"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(params[:upload][:file].read) }
    flash[:notice] = "File uploaded"
    redirect_to "/upload/new"





=begin
		uploaded_file = params[:file]
		
		respond_to do |format|
			format.html { 
				session[:file_content] = uploaded_file.read
				redirect_to analyze_path 
			}
		end
=end
	end

	require 'string'
	def analyze
		@content = session[:file_content] || ''

		@content = @content.to_stem
	end
end
