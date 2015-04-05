class UploadController < ApplicationController

	def index
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

	def analyze
		@content = session[:file_content]
		session[:file_content] = nil
	end
end
