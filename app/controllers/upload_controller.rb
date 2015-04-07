class UploadController < ApplicationController

	def index
		if !session[:filename].nil?
			redirect_to cleanup_path
		end
	end

	def create

		text_file = TextFile.new
		if session[:filename] = text_file.save(params[:upload])
			flash[:success] = 'File upload successful!'
			redirect_to analyze_path
		else
			flash[:danger] = text_file.flash_error
			redirect_to root_path
		end

	end

	require 'string'
	def analyze
		@filename = session[:filename]

		if @filename.nil? or !File.exist?("#{Rails.root}/public/txt/#{@filename}")
			redirect_to root_path
		else
			# read file contents into variable
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
