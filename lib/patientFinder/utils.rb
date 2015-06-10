require 'rubygems'
require 'nokogiri'
require 'health-data-standards'
require 'zip/zipfilesystem'
require 'fileutils'
require 'health-data-standards'
Mongoid.load!("mongoid.yml", :development)

module PatientFinder
    # a collection of utilities grouped together under the same roof
    class Utils
    
    	#resolves the candidates to the test files (one test file - one candidate - when multiple candidates are found manual anotation is used)
    	def self.get_MRN_for_tests(candidates,test_record,test_to_MRN_hash)
    
    
    		#currently the candidates are records - get only the IDs out of all those records
    		# candidate_MRNs=Utils::collectMedicalRecordNumbers(candidates)
    		candidate_MRNs=candidates.map(&:medical_record_number)
    
    		if(candidate_MRNs.length==1)
    			test_to_MRN_hash[test_record.fileName]=candidate_MRNs.first			
    		elsif((candidate_MRNs.length==2) & (candidate_MRNs & ["ee85c89f24946e2ddca12c6edc5181dc", "eb6af018e11320f5c163624beb83767d"]).present?)
    			test_to_MRN_hash[test_record.fileName]="ee85c89f24946e2ddca12c6edc5181dc"			
    		elsif((candidate_MRNs.length==4) & (candidate_MRNs & ["7a86cc6d87cb84461ea190e7c706d81b", "1be81ce59da982792026cc82d95bc10e","511b530c8662f8df97eb97b3eefa0618","258ee9087c5a5fe359ceb3aafff0dd76"]).present?)
    			test_to_MRN_hash[test_record.fileName]="258ee9087c5a5fe359ceb3aafff0dd76"			
    		elsif((candidate_MRNs.length==4) & (candidate_MRNs & ["0a26a978d07240b0f917e96727db31d8","ee85c89f24946e2ddca12c6edc5181dc","343731b99c6bdb35a1fc31ce9ed6f889","eb6af018e11320f5c163624beb83767d"]).present?)
    			test_to_MRN_hash[test_record.fileName]="0a26a978d07240b0f917e96727db31d8"	
    		elsif((candidate_MRNs.length==2) & (candidate_MRNs & ["929dd1f2c4c54c024fd4d18b1307fdb1", "29cecb1da08efd331fce823e12b607d5"]).present?)
    			test_to_MRN_hash[test_record.fileName]="929dd1f2c4c54c024fd4d18b1307fdb1"	
    		elsif((candidate_MRNs.length==2) & (candidate_MRNs & ["5f118631f09abdbdeb1962dc28bfeb27", "a6300c43651965991a4308ffaeb5381d"]).present?)
    			test_to_MRN_hash[test_record.fileName]="5f118631f09abdbdeb1962dc28bfeb27"	
    		elsif((candidate_MRNs.length==2) & (candidate_MRNs & ["7a86cc6d87cb84461ea190e7c706d81b", "258ee9087c5a5fe359ceb3aafff0dd76"]).present?)
    			test_to_MRN_hash[test_record.fileName]="258ee9087c5a5fe359ceb3aafff0dd76"	
    		elsif((candidate_MRNs.length>8) & (candidate_MRNs & ["fed089904c10b81c036adddedddebe7b", "846c1c2ba8370c2f5504b315cc4b1d5d", "b5633133e3421216ced2bdef4dbf382d", "0a26a978d07240b0f917e96727db31d8","ee85c89f24946e2ddca12c6edc5181dc","b54a4e3ab37de7e5f8094793afb8a699","2678a4e396aaec03b860d5aeadcad8e6","929dd1f2c4c54c024fd4d18b1307fdb1","fdea0c22270417d9e59f20b07f642679","91bd37f9cebf7b6ef9f72d7fd6148a81","0085074bb549ffefffa6e16ff34df140","343731b99c6bdb35a1fc31ce9ed6f889","eb6af018e11320f5c163624beb83767d","470f57b022eaeffd4d599078e851a56d","0dbaf9336f7aa1590265250a0eebe548","29cecb1da08efd331fce823e12b607d5","d156a6d38e10efc30eda3cace7456537","8130b2ff5774f1593c86eba8dca4c37b","697e147f076648275e518e7b3ff41dcd"]).present?)
    			test_to_MRN_hash[test_record.fileName]="fed089904c10b81c036adddedddebe7b"	
    		else
    			for v in candidate_MRNs
    				puts "\t#{v}"
    			end 
    		end
    	end	
    
    	# #extracts the ids from a set of records 
    	# def self.collectMedicalRecordNumbers(candidates)
    	# 	ids=Array.new
    	# 	for candidate in candidates
     #   		ids<< candidate.medical_record_number
    	# 	end
    	# 	ids
    	# end
    
    	#a utility that iterates through a set of master records to find possible matches (candidates) for a test cord
    	def self.get_candidates_for_test(master_records,test_record)
    		
    		candidates=Array.new
    		# candidates
    		master_records.each { |master_record|
    				#simple conditions that will reduce the record pool
    			if(master_record.gender==test_record.gender && master_record.ethnicity[:code]==test_record.ethnicity[:code] && master_record.race[:code] == test_record.race[:code])
    				#go inside the sections and collect codes and find if the codes from the test are ALL contained in the the same section of the master 
    				# sections = [:allergies, :care_goals, :conditions, :encounters, :immunizations, :medical_equipment, :medications, :procedures, :insurance_providers ]
    				# master_is_match = sections.all? {|section| Utils::matchCodes(testRecord[section],master_record[section])}
    				
    				# if(master_is_match)
    				# 	candidates<< master_record
    				# end
    				
    				allergiesMatch=Utils::codes_match?(test_record.allergies,master_record.allergies)
    				care_goalsMatch=Utils::codes_match?(test_record.care_goals,master_record.care_goals)
    				conditionsMatch=Utils::codes_match?(test_record.conditions,master_record.conditions)
    				encountersMatch=Utils::codes_match?(test_record.encounters,master_record.encounters)
    				immunizationsMatch=Utils::codes_match?(test_record.immunizations,master_record.immunizations)
    				medical_equipmentMatch=Utils::codes_match?(test_record.medical_equipment,master_record.medical_equipment)
    				medicationsMatch=Utils::codes_match?(test_record.medications,master_record.medications)
    				proceduresMatch=Utils::codes_match?(test_record.procedures,master_record.procedures)
    				insurance_providersMatch=Utils::codes_match?(test_record.insurance_providers,master_record.insurance_providers)
    
    				#create candidates based on matching codes - if all the above match then consider this master as candidate
    				if(allergiesMatch && care_goalsMatch && conditionsMatch && encountersMatch &&  immunizationsMatch && medical_equipmentMatch &&  medicationsMatch && proceduresMatch &&  insurance_providersMatch)
    					candidates<< master_record
    				end
    			end	
    		}
    		candidates
    	end
    
    	#a utility that loads into mongoDB records from a zip containing QRDA files 
    	def self.get_PatientFromQRDA_from_zip(zip)
    		patients_from_QRDAs = Array.new
    		zip_archive = open(zip)
    		Zip::ZipFile.open(zip_archive.path) do |zip_file|
    			zip_file.entries.each do |entry|

    				data =zip_file.read(entry.name)
    				doc = Nokogiri::XML(data)

    				doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    				doc.root.add_namespace_definition('sdtc', 'urn:hl7-org:sdtc')

    				patient_data = HealthDataStandards::Import::Cat1::PatientImporter.instance.parse_cat1(doc)

    				patient = Record.update_or_create(patient_data)

    				patientFromQRDA = PatientFinder::PatientFromQRDA.new(entry.name, patient)
    				patients_from_QRDAs << patientFromQRDA
    			end
    		end
    		patients_from_QRDAs
    	end
    
    	def self.create_code_hash(thisEntry, code_hash)
    		thisEntry.codes.each_pair do |code_set, coded_values|
    			coded_values.each do |coded_value|
    				code_hash[coded_value]=code_set
    			end
    		end
    	end
    
    	#identifies if all the codes in a particular section of the test are in the same section of the master
    	def self.codes_match?(test_entries,master_entries)
    
    		test_codes_hash= Hash.new 
    		test_entries.each do |this|
    			create_code_hash(this, test_codes_hash)
    		end
    
    		master_code_hash= Hash.new 
    		master_entries.each do |this|
    			create_code_hash(this, master_code_hash)
    		end
    		(test_codes_hash.to_a - master_code_hash.to_a).empty?
    	end
    
    	#collects records from a Cypress mongo db
    	def self.get_master_records_from_cypress
    	    #TODO remove the production refrence - but first move all the master records into development - we will be using only development at that point
    		Mongoid.load!("mongoid.yml", :production)
    		Record.all_of(:last.in => [ /\b[A-Z]\b/])
    	end
    end
end