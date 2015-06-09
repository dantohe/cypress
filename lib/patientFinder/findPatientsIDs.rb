#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'
require 'health-data-standards'
require 'zip/zipfilesystem'
require 'fileutils'
require 'health-data-standards'

#a simple patient from QRDA - contains the source files name and the parsed record associated
class PatientFromQRDA
	attr_accessor :fileName, :patient
	def initialize(fileName, patient)
		@fileName=fileName
		@patient=patient
	end
end


# the main processor 
class MRNfinder
	
	attr_accessor :testQRDAFile

	#constructor
	def initialize (testQRDAFile)
		@testQRDAFile=testQRDAFile
	end
	

	# loads the patient (records) from the archived QRDA file 
	def findOriginalMRNForTests
		#the test patinets are loaded from the file
		testPatients=Utils::collectQRDAPatientsFromZip(testQRDAFile)
		#the master records are loaded from Cypress production 
		masterRecords=Utils::getMasterRecordsFromCypress
		puts "\nLoaded #{testPatients.length} test patients"
		puts "Loaded #{masterRecords.length} master patients\n"
		print "Processing...."
		iterateThroughRecordsAndWriteQueries(masterRecords, testPatients)
	end

	#find matches for test patients
	def iterateThroughRecordsAndWriteQueries(masterRecords, testPatients)

		#store the results
		testToMasterHash= Hash.new

		for testRecord in testPatients
			#iterate through master records and find candidates 
			print "."
			candidates= Utils::iterateThroughMasterRecordsAndFindCandidates(masterRecords, testRecord.patient)
			#resolve cadidates to unique MRNs - with other words resolve the candidates
			Utils::getUniqueMedicalRecordNumber(candidates,testRecord,testToMasterHash)
		end

		#print results
		puts ""
		testToMasterHash.each_pair do |key, value|
			puts "#{key}\t\t\t#{value}"
		end
	end


end


# a collection of utilities grouped together under the same roof
class Utils

	def self.getUniqueMedicalRecordNumber(candidates,testRecord,testToMasterHash)


		#currently the candidates are records - get only the IDs out of all those records
		candidateIDs=Utils::collectMedicalRecordNumbers(candidates)

		if(candidateIDs.length==1)
			testToMasterHash[testRecord.fileName]=candidateIDs.first			
		elsif((candidateIDs.length==2) & (candidateIDs & ["ee85c89f24946e2ddca12c6edc5181dc", "eb6af018e11320f5c163624beb83767d"]).present?)
			testToMasterHash[testRecord.fileName]="ee85c89f24946e2ddca12c6edc5181dc"			
		elsif((candidateIDs.length==4) & (candidateIDs & ["7a86cc6d87cb84461ea190e7c706d81b", "1be81ce59da982792026cc82d95bc10e","511b530c8662f8df97eb97b3eefa0618","258ee9087c5a5fe359ceb3aafff0dd76"]).present?)
			testToMasterHash[testRecord.fileName]="258ee9087c5a5fe359ceb3aafff0dd76"			
		elsif((candidateIDs.length==4) & (candidateIDs & ["0a26a978d07240b0f917e96727db31d8","ee85c89f24946e2ddca12c6edc5181dc","343731b99c6bdb35a1fc31ce9ed6f889","eb6af018e11320f5c163624beb83767d"]).present?)
			testToMasterHash[testRecord.fileName]="0a26a978d07240b0f917e96727db31d8"	
		elsif((candidateIDs.length==2) & (candidateIDs & ["929dd1f2c4c54c024fd4d18b1307fdb1", "29cecb1da08efd331fce823e12b607d5"]).present?)
			testToMasterHash[testRecord.fileName]="929dd1f2c4c54c024fd4d18b1307fdb1"	
		elsif((candidateIDs.length==2) & (candidateIDs & ["5f118631f09abdbdeb1962dc28bfeb27", "a6300c43651965991a4308ffaeb5381d"]).present?)
			testToMasterHash[testRecord.fileName]="5f118631f09abdbdeb1962dc28bfeb27"	
		elsif((candidateIDs.length==2) & (candidateIDs & ["7a86cc6d87cb84461ea190e7c706d81b", "258ee9087c5a5fe359ceb3aafff0dd76"]).present?)
			testToMasterHash[testRecord.fileName]="258ee9087c5a5fe359ceb3aafff0dd76"	
		elsif((candidateIDs.length>8) & (candidateIDs & ["fed089904c10b81c036adddedddebe7b", "846c1c2ba8370c2f5504b315cc4b1d5d", "b5633133e3421216ced2bdef4dbf382d", "0a26a978d07240b0f917e96727db31d8","ee85c89f24946e2ddca12c6edc5181dc","b54a4e3ab37de7e5f8094793afb8a699","2678a4e396aaec03b860d5aeadcad8e6","929dd1f2c4c54c024fd4d18b1307fdb1","fdea0c22270417d9e59f20b07f642679","91bd37f9cebf7b6ef9f72d7fd6148a81","0085074bb549ffefffa6e16ff34df140","343731b99c6bdb35a1fc31ce9ed6f889","eb6af018e11320f5c163624beb83767d","470f57b022eaeffd4d599078e851a56d","0dbaf9336f7aa1590265250a0eebe548","29cecb1da08efd331fce823e12b607d5","d156a6d38e10efc30eda3cace7456537","8130b2ff5774f1593c86eba8dca4c37b","697e147f076648275e518e7b3ff41dcd"]).present?)
			testToMasterHash[testRecord.fileName]="fed089904c10b81c036adddedddebe7b"	
		else
			for v in candidateIDs
				puts "\t#{v}"
			end 
		end
	end	

	#extracts the ids from a set of records 
	def self.collectMedicalRecordNumbers(candidates)
		ids=Array.new
		for candidate in candidates
    		ids<< candidate.medical_record_number
		end
		ids
	end

	#a utility that iterates through a set of master records to find possible matches (candidates) for a test cord
	def self.iterateThroughMasterRecordsAndFindCandidates(masterRecords,testRecord)
		candidates=Array.new 
		for masterRecord in masterRecords
			#simple conditions that will reduce the record pool
			if(masterRecord.gender==testRecord.gender && masterRecord.ethnicity[:code]==testRecord.ethnicity[:code] && masterRecord.race[:code] == testRecord.race[:code])
				#go inside the sections and collect codes and find if the codes from the test are ALL contained in the the same section of the master 
				allergiesMatch=Utils::matchCodes(testRecord.allergies,masterRecord.allergies)
				care_goalsMatch=Utils::matchCodes(testRecord.care_goals,masterRecord.care_goals)
				conditionsMatch=Utils::matchCodes(testRecord.conditions,masterRecord.conditions)
				encountersMatch=Utils::matchCodes(testRecord.encounters,masterRecord.encounters)
				immunizationsMatch=Utils::matchCodes(testRecord.immunizations,masterRecord.immunizations)
				medical_equipmentMatch=Utils::matchCodes(testRecord.medical_equipment,masterRecord.medical_equipment)
				medicationsMatch=Utils::matchCodes(testRecord.medications,masterRecord.medications)
				proceduresMatch=Utils::matchCodes(testRecord.procedures,masterRecord.procedures)
				insurance_providersMatch=Utils::matchCodes(testRecord.insurance_providers,masterRecord.insurance_providers)

				#create candidates based on matching codes - if all the above match then consider this master as candidate
				if(allergiesMatch && care_goalsMatch && conditionsMatch && encountersMatch &&  immunizationsMatch && medical_equipmentMatch &&  medicationsMatch && proceduresMatch &&  insurance_providersMatch)
					candidates<< masterRecord
				end
			end	
		end	
		candidates
	end

	#a utility that loads into mongoDB records from a zip containing QRDA files 
	def self.collectQRDAPatientsFromZip(zipFile)
		patientsFromQRDAs = Array.new
		zipFilex = open(zipFile)
		Zip::ZipFile.open(zipFilex.path) do |zipfile|
			zipfile.entries.each do |entry|
				data =zipfile.read(entry.name)
				
				doc = Nokogiri::XML(data)
				doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
				doc.root.add_namespace_definition('sdtc', 'urn:hl7-org:sdtc')
				patient_data = HealthDataStandards::Import::Cat1::PatientImporter.instance.parse_cat1(doc)
				patient = Record.update_or_create(patient_data)
				patientFromQRDA = PatientFromQRDA.new(entry.name, patient)
				patientsFromQRDAs << patientFromQRDA
			end
		end
		patientsFromQRDAs
	end

	def self.createCodeHash(thisEntry, patientCodesHash)
		thisEntry.codes.each_pair do |code_set, coded_values|
			coded_values.each do |coded_value|
				patientCodesHash[coded_value]=code_set
			end
		end
	end

	#identifies if all the codes in a particular section of the test are in the same section of the master
	def self.matchCodes(testEntries,masterEntries)
		result = false

		testCodesHash= Hash.new 
		testEntries.each do |thisEntry|
			createCodeHash(thisEntry, testCodesHash)
		end

		masterCodesHash= Hash.new 
		masterEntries.each do |thisEntry|
			createCodeHash(thisEntry, masterCodesHash)
		end

		if (testCodesHash.to_a - masterCodesHash.to_a).empty?
			result=true
		end
		result		
	end

	#collects records from a Cypress mongo db
	def self.getMasterRecordsFromCypress
		Mongoid.load!("mongoid.yml", :production)
		masterRecords = Record.all_of(:last.in => [ /\b[A-Z]\b/])
		masterRecords
	end
end

if(ARGV.length<1)
	puts "One argument is needed: \n\tthe path to the zip containing the QRDA1 test files"
	puts "Example: \n\tbundle exec ruby findPatientsIDs.rb test/T63-22.zip"
	abort
end



Mongoid.load!("mongoid.yml", :development)
#instantiate with an collection archived collection of QRDA1 files
patientFinder = MRNfinder.new(ARGV[0])
#process the records and retrive original MRNs
patientFinder.findOriginalMRNForTests