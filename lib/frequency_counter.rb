module FrequencyCounter

	require 'porter_stemmer'

	# Returns an array of [word, frequency] pairs, sorted in descending
	# frequency count with ties broken by alphabetical order
	def frequency
		str = self.dup.to_str

		# Create hashtable to store results
		freq = Hash.new
		clean_text = str.gsub(/[.,!?]/, ' ').downcase
		clean_text.split.each do |w|
			stem = w.to_stem 
			freq[stem] = freq.has_key?(stem) ? freq[stem]+1 : 1
		end

		# sort by descending order, then by alphabetical order
		freq.sort_by { |k,v| [-v, k] }
	end

end