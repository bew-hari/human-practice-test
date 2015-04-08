module PorterStemmer
	
	# Define constants
	V = '[aeiouy]'												# vowel
	C = '[^aeiouy]'												# consonant (non-vowel)
	D = '(bb|dd|ff|gg|mm|nn|pp|rr|tt)'		# double
	L = '[cdeghknmrt]'										# valid li-ending

	# Define short syllable as 
	# 	a. a vowel followed by a non-vowel other than w, x or Y
	# 	b. a vowel at the beginning of the word followed by a non-vowel
	SS_A = "#{C}#{V}[^aeiouywxY]"
	SS_B = "^#{V}#{C}"

	# Map replacement suffixes for steps 2 and 3
	STEP_2_MAP = {
	  'tional'	=> 'tion', 
	  'enci'		=> 'ence', 
	  'anci'		=> 'ance',
	  'abli'		=> 'able',
	  'entli'		=> 'ent',
	  'izer'		=> 'ize', 
	  'ization'	=> 'ize', 
	  'ational'	=> 'ate', 
	  'ation'		=> 'ate',
	  'ator'		=> 'ate', 
	  'alism'		=> 'al', 
	  'aliti'		=> 'al', 
	  'alli'		=> 'al', 
	  'fulness'	=> 'ful',
	  'ousli'		=> 'ous', 
	  'ousness'	=> 'ous',
	  'iveness'	=> 'ive',
	  'iviti'		=> 'ive', 
	  'biliti'	=> 'ble',
	  'bli'			=> 'ble', 
	  'ogi'			=> 'og',
	  'fulli'		=> 'ful', 
	  'lessli'	=> 'less'
	}

	STEP_3_MAP = {
		'tional'	=> 'tion',
		'ational'	=> 'ate',
		'alize'		=> 'al',
		'icate'		=> 'ic',
		'iciti'		=> 'ic',
		'ical'		=> 'ic'
	}


	# Returns region after the first non-vowel following a vowel, 
	# or the end of the word if there is no such non-vowel
	def r1
		w = self.dup.to_str
		r1 = w =~ /#{V}#{C}/o ? $' : ''
	end


	# Returns stem of word using the English (Porter2) stemming algorithm
	def to_stem
		w = self.dup.to_str

		# Leave as is, if word is 2 characters or less
		return w if w.length < 3

		# Remove initial apostrophe if exists
		w = w[1..-1] if w[0] == "'"

		# Set initial y, or y after a vowel, to Y
		w[0] == 'Y' if w[0] == 'y'
		w.gsub!(/(#{V})y/o, $1+'Y')
		
		#while w =~ /(#{V})y/o
		#	w = $` + $1 + 'Y' + $'
		#end

		# Define regions r1 and r2 as
		# 	r1: region after the first non-vowel following a vowel, 
		# 			or the end of the word if there is no such non-vowel
		#
		# 	r2: region after the first non-vowel following a vowel in R1, 
		# 			or the end of the word if there is no such non-vowel
		#
		r1 = w.r1
		r2 = r1.r1


		
		# Step 0:
		# 	Search for the longest among the suffixes, 
		#
		# 		'
		# 		's
		# 		's'
		#
		# 	and remove if found
		w = $` if w =~ /( 's' | 's | ' )$/x

		#puts 'Step 0: ' + w





		# Step 1a:
		# 	Search for the longest among the following suffixes, 
		# 	and perform the action indicated. 
		#
		# 		sses						replace by ss
		#
		# 		ied, ies				replace by i if preceded by more than 
		# 											one letter, otherwise by ie
		#
		# 		us, ss 					leave as is
		#
		# 		s 							delete if the preceding word part contains 
		# 											a vowel not immediately before the s
		#
		if w =~ /( sses | ied | ies | us | ss | s )$/x
			stem = $`
			suffix = $1
			case suffix
			when 'sses'					then w = stem + 'ss'
			when 'ied','ies'		then w = stem + (stem.length > 1 ? 'i' : 'ie')
			when 'us','ss'			then w = stem + $1
			when 's'						then w.chop! if stem =~ /#{V}/ and !$'.empty?
			end
		end

		#puts 'Step 1a: ' + w





		# Step 1b:
		# 	Search for the longest among the following suffixes, 
		# 	and perform the action indicated. 
		#
		# 		eed, eedly			replace by ee if in R1
		#
		# 		ed, edly, ing, ingly				
		# 				delete if the preceding word part contains a vowel, 
		# 				and after the deletion:
		# 					if the word ends at, bl or iz add e, or
		# 					if the word ends with a double remove the last letter, or
		# 					if the word ends in a short syllable and r1 is null, add e
		#
		if w =~ /( ingly | ing | eedly | edly | eed | ed )$/x
			stem = $`
			suffix = $1
			case suffix
			when 'eed','eedly'
				w = stem + 'ee' if w.r1.include? suffix
			when 'ed','edly','ing','ingly'
				if stem =~ /#{V}/o
					w = stem
					case w
	      	when /(at|bl|iz)$/					then w += 'e'
	      	when /#{D}$/o 							then w.chop!
	      	when /(#{SS_A}|#{SS_B})$/o 	then w += 'e' if w.r1.empty?
	      	end
				end
			end
		end

		#puts 'Step 1b: ' + w





		# Step 1c:
		# 	Replace suffix y or Y by i if preceded by a non-vowel which is not 
		# 	the first letter of the word.
		#
		w[-1] = 'i' if w =~ /#{C}(y|Y)$/ and w.length > 2

		#puts 'Step 1c: ' + w





		# Step 2:
		# 	Search for the longest among the following suffixes, and, if found 
		# 	and in R1, perform the action indicated.
		#
		# 		tional									replace by tion
		# 		enci										replace by ence
		# 		anci										replace by ance
		# 		abli										replace by able
		# 		entli										replace by ent
		# 		izer, ization						replace by ize
		# 		ational, ation, ator		replace by ate
		# 		alism, aliti, alli			replace by al
		# 		fulness									replace by ful
		# 		ousli, ousness					replace by ous
		# 		iveness, iviti					replace by ive
		# 		biliti, bli 						replace by ble
		# 		ogi 										replace by og if preceded by l
		# 		fulli										replace by ful
		# 		lessli									replace by less
		# 		li 											delete if preceded by a valid li-ending
		# 		
		if w =~ /( ization	|	izer	|
							 ational	| ation |	ator	|
							 tional		|
							 enci			|
							 anci			|
							 abli			|
							 entli		|
							 alism 		|	aliti	| alli	|
							 fulness	|
							 ousness	|	ousli	|
							 iveness	|	iviti	|
							 biliti		|	bli		|
							 ogi			|
							 fulli		|
							 lessli		| 
							 li 			)$/x
	    stem = $`
	    suffix = $1
	    if w.r1.include? suffix
	    	case suffix
		    when 'ogi'			then w = stem + STEP_2_MAP[suffix] if stem[-1] == 'l'
		    when 'li'				then w = stem if stem =~ /#{L}$/o
		    else								 w = stem + STEP_2_MAP[suffix]
		    end
	    end
	  end

	  #puts 'Step 2: ' + w





	  # Step 3:
		# 	Search for the longest among the following suffixes, and, if found 
		# 	and in R1, perform the action indicated.
		#
		# 		tional									replace by tion
		# 		ational									replace by ate
		# 		alize										replace by al
		# 		icate, iciti, ical			replace by ic
		# 		ful, ness								delete
		# 		ative										delete if in R2
		#
		if w =~ /( ational	|
							 tional		|
							 alize		|
							 icate		|	iciti	|	ical	|
							 ful 			| ness	|
							 ative 		)$/x
			stem = $`
	  	suffix = $1
	    if w.r1.include? suffix
	    	case suffix
		    when 'ful','ness'			then w = stem
		    when 'ative'					then w = stem if w.r1.r1.include? suffix
		    else											 w = stem + STEP_3_MAP[suffix]
		    end
	    end
		end

		#puts 'Step 3: ' + w





		# Step 4:
		# 	Search for the longest among the following suffixes, 
		# 	and, if found and in R2, perform the action indicated.
		#
		# 		al, ance, ence, er, 				delete
		# 		ic, able, ible, ant, 
		# 		ement, ment, ent, ism, 
		# 		ate, iti, ous, ive, ize
		# 
		#
		# 		ion													delete if preceded by s or t
		#
		if w =~ /( al 	 | ance 	| ence 	| er		|
							 ic		 | able 	| ible	|	ant		|
							 ement | ment 	|	ent 	| ism 	|
							 ate 	 | iti 		| ous 	| ive 	| 
							 ize 	 | ion 		)$/x
			stem = $`
	    suffix = $1
	    if w.r1.r1.include? suffix
	    	case suffix
	    	when 'ion'			then w = stem if stem =~ /[st]$/
	    	else								 w = stem
	    	end
	    end
		end

		#puts 'Step 4: ' + w





		# Step 5:
		# 	Search for the the following suffixes, 
		# 	and, if found, perform the action indicated.
		#
		# 		e 			delete if in R2, or in R1 and not preceded by 
		#  							a short syllable
		#
		# 		l 			delete if in R2 and preceded by l
		#
		if w =~ /(e|l)$/
			stem = $`
	    suffix = $1
	    case suffix
	    when 'e'
	    	if w.r1.r1.include? suffix or 
	    		 (w.r1.include? suffix and !(stem =~ /(#{SS_A}|#{SS_B})$/o))
	    		 w = stem
	    	end
	    when 'l'
	    	if w.r1.r1.include? suffix and stem =~ /l$/
	    		w = stem
	    	end
	    end
	  end

	  #puts 'Step 5: ' + w

	  # restore y
	  w.gsub(/Y/, 'y')

	  # Return stem
		w
	end

end