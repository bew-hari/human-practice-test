class UploadController < ApplicationController

	def index
		if !session[:filename].nil?
			redirect_to cleanup_path
		end
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
			@notice = "Looks like you haven't uploaded a file."
			@content = @frequency_count = ''
		else
			# read file contents into variable
			@notice = ''
			@content = File.read("#{Rails.root}/public/txt/#{@filename}")
			@frequency_count = @content.frequency
		end

	end


	def cleanup
		@filename = session[:filename]

		if !@filename.nil? and File.exist?("#{Rails.root}/public/txt/#{@filename}")
			File.delete("#{Rails.root}/public/txt/#{@filename}") 
		end

		session[:filename] = nil
		redirect_to root_path
	end

end
