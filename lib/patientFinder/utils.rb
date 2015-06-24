require 'rubygems'
require 'nokogiri'
require 'health-data-standards'
require 'zip/zipfilesystem'
require 'fileutils'
require 'health-data-standards'
require 'pry'
# Mongoid.load!("mongoid.yml", :development)

module PatientFinder
# a collection of utilities grouped together under the same roof
    class Utils

        #some of records are created ambiguous on purpose (fr example some of them contain only encounters) - in order to disambiguate human intervention is needed - the following hash resolves the ambiguos cases

        AMBIGUOUS_PATIENTS = {["ee85c89f24946e2ddca12c6edc5181dc", "eb6af018e11320f5c163624beb83767d"] => "ee85c89f24946e2ddca12c6edc5181dc",
            ["0a26a978d07240b0f917e96727db31d8","ee85c89f24946e2ddca12c6edc5181dc","343731b99c6bdb35a1fc31ce9ed6f889","eb6af018e11320f5c163624beb83767d"] => "0a26a978d07240b0f917e96727db31d8",
            ["929dd1f2c4c54c024fd4d18b1307fdb1", "29cecb1da08efd331fce823e12b607d5"] => "929dd1f2c4c54c024fd4d18b1307fdb1",
            ["5f118631f09abdbdeb1962dc28bfeb27", "a6300c43651965991a4308ffaeb5381d"] => "5f118631f09abdbdeb1962dc28bfeb27",
            ["7a86cc6d87cb84461ea190e7c706d81b", "258ee9087c5a5fe359ceb3aafff0dd76"] => "258ee9087c5a5fe359ceb3aafff0dd76",
            ["7a86cc6d87cb84461ea190e7c706d81b", "1be81ce59da982792026cc82d95bc10e","511b530c8662f8df97eb97b3eefa0618","258ee9087c5a5fe359ceb3aafff0dd76"] => "258ee9087c5a5fe359ceb3aafff0dd76",
            ["fed089904c10b81c036adddedddebe7b", "846c1c2ba8370c2f5504b315cc4b1d5d", "b5633133e3421216ced2bdef4dbf382d",
                "0a26a978d07240b0f917e96727db31d8","ee85c89f24946e2ddca12c6edc5181dc","b54a4e3ab37de7e5f8094793afb8a699","2678a4e396aaec03b860d5aeadcad8e6","929dd1f2c4c54c024fd4d18b1307fdb1",
                "fdea0c22270417d9e59f20b07f642679","91bd37f9cebf7b6ef9f72d7fd6148a81","0085074bb549ffefffa6e16ff34df140","343731b99c6bdb35a1fc31ce9ed6f889","eb6af018e11320f5c163624beb83767d","470f57b022eaeffd4d599078e851a56d",
                "0dbaf9336f7aa1590265250a0eebe548","29cecb1da08efd331fce823e12b607d5","d156a6d38e10efc30eda3cace7456537","8130b2ff5774f1593c86eba8dca4c37b","697e147f076648275e518e7b3ff41dcd"] => "fed089904c10b81c036adddedddebe7b"}

        #find matches for test patients
        def self.get_MRNs(master_records, test_patients)

            #store the results
            tests_to_MRNs= Hash.new

            #iterate through master records and find candidates
            test_patients.each { |test_patient|
                #each test patient might have one or more MRN candidates
                candidates = get_candidates_for_test(master_records, test_patient.record)

                #resolve cadidates to unique MRNs - with other words resolve the candidates
                tests_to_MRNs[test_patient.fileName]=get_MRN_for_tests(candidates.map(&:medical_record_number))
            }

            tests_to_MRNs
        end

        #resolves ambiguos candidates to a unique MRN
        def self.get_MRN_for_ambiguous(candidate_MRNs)
            AMBIGUOUS_PATIENTS.each_pair {  |ambiguous_entries, mrn|
                return mrn if (candidate_MRNs-ambiguous_entries).empty?
            }
            "too ambiguous #{candidate_MRNs}"
        end


        #resolves the candidates - if one single candidate found then retunr that - if more then resolve them through disambiguation
        def self.get_MRN_for_tests(candidate_MRNs)

            return candidate_MRNs.first if(candidate_MRNs.length==1)
            return get_MRN_for_ambiguous(candidate_MRNs) if (candidate_MRNs.length>1)
        end

        #a utility that iterates through a set of master records to find possible matches (candidates) for a test cord
        def self.get_candidates_for_test(master_records,test_record)

            candidates=Array.new
            # candidates
            master_records.each { |master_record|

                #simple conditions that will reduce the record pool
                if(master_record.gender==test_record.gender &&
                    master_record.ethnicity[:code]==test_record.ethnicity[:code] &&
                    master_record.race[:code] == test_record.race[:code])

                    #go inside the sections and collect codes and find if the codes from the test are ALL contained in the the same section of the master
                    sections = [:allergies, :care_goals, :conditions, :encounters, :immunizations, :medical_equipment, :medications, :procedures, :insurance_providers ]
                    sections_with_data = sections.select { |section| test_record[section].present? }

                    master_is_match = sections_with_data.all? {|section| codes_match?(test_record.send(section), master_record.send(section))}

                    if(master_is_match)
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



        #collects master records from a Cypress mongo db
        def self.get_master_records_from_cypress
            Record.all_of(:last.in => [ /\b[A-Z]\b/])
        end

        private
        #entries can be allergies, encounters etc
        def self.get_hash_out_of_entries(entries)
             code_hash= Hash.new
             entries.each do |thisEntry|
                 thisEntry.codes.each_pair do |code_set, coded_values|
                     coded_values.each do |coded_value|
                         code_hash[coded_value]=code_set
                     end
                 end
             end
             code_hash
        end

        #identifies if all the codes in a particular section of the test are in the same section of the master
        def self.codes_match?(test_entries,master_entries)

            test_codes_hash = get_hash_out_of_entries(test_entries)
            master_code_hash = get_hash_out_of_entries(master_entries)

            (test_codes_hash.to_a - master_code_hash.to_a).empty?
        end

        private_class_method :get_hash_out_of_entries, :codes_match?

    end
end