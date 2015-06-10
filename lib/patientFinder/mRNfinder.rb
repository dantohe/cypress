require_relative 'patientFromQRDA.rb'
require_relative 'utils.rb'
module PatientFinder

    # finds the original (master) Cypress medical_record_number for each file in an archive
    class MRNfinder
        
        attr_accessor:test_archive
    
        #constructor using the test archive
        def initialize (test_archive)
        @test_archive=test_archive
        end
    
        # loads the patient (records) from the archived QRDA file 
        def get_original_MRNs_for_tests
            
            #the test patinets are loaded from the file
        test_patients=PatientFinder::Utils::get_PatientFromQRDA_from_zip(test_archive)
            
            #the master records are loaded from Cypress production 
        master_records=PatientFinder::Utils::get_master_records_from_cypress

            #return the results in a hash            
            get_MRN_for_tests(master_records, test_patients)
        end
    
        private
        #find matches for test patients
        def get_MRN_for_tests(master_records, test_patients)
    
            #store the results
        tests_to_MRNs= Hash.new
            
            #iterate through master records and find candidates 
            test_patients.each { |test_patient|
                #each test patient might have one or more MRN candidates
        candidates= PatientFinder::Utils::get_candidates_for_test(master_records, test_patient.record)
                
                #resolve cadidates to unique MRNs - with other words resolve the candidates
        PatientFinder::Utils::get_MRN_for_tests(candidates, test_patient, tests_to_MRNs)
            }
    
            tests_to_MRNs
        end
    end
end

