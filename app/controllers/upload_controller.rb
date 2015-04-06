class UploadController < ApplicationController

	def index
		session[:file_content] = nil
	end

	def create
		uploaded_file = params[:file]
		
		respond_to do |format|
			format.html { 
				session[:file_content] = uploaded_file.read
				redirect_to analyze_path 
			}
		end
	end

	require 'string'
	def analyze
		@content = session[:file_content] || ''

		@content = @content.to_stem
	end
end
