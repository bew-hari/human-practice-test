class UploadController < ApplicationController

	def index
		session[:filename] = nil
	end

	def create
		if session[:filename] = TextFile.save(params[:upload])
			flash[:success] = 'File upload successful!'
			redirect_to analyze_path
		else
			flash[:danger] = 'File upload failed.'
			redirect_to root_path
		end

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
		@filename = session[:filename]

		if @filename.nil?
			@content = "Looks like you haven't uploaded a file."
		else
			# read file contents into variable
			@content = File.read("#{Rails.root}/public/txt/#{@filename}")
		end

	end


	def cleanup
		@filename = session[:filename]

		if !@filename.nil? and File.exist?("#{Rails.root}/public/txt/#{@filename}")
			File.delete("#{Rails.root}/public/txt/#{@filename}") 
		end

		redirect_to root_path
	end

end
