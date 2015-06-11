require_relative '../../utils.rb'
require 'minitest/autorun'

class TestUtils <  Minitest::Test
    #this is a bit dummy given the class functionality 
    QRDA1_PATIENT_FILE = "test/fixtures/artifacts/0_Hazel_Abbott.xml"
    PATIENT_NAME = "Hazel Abbott"
    EXPECTED_NUMBER_OF_MASTER_PATIENTS=56
    
    def test_fileName
        assert_equal(56, PatientFinder::Utils.get_master_records_from_cypress.length)
    end
    
    def test_record_name
        # assert_equal(1, 1)
    end
    
    def setup
        # puts
        # xml = File.open(QRDA1_PATIENT_FILE,"r") do |f| f.read() end
        # doc = Nokogiri::XML(xml)
        # doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
        # doc.root.add_namespace_definition('sdtc', 'urn:hl7-org:sdtc')
        # patient_data = HealthDataStandards::Import::Cat1::PatientImporter.instance.parse_cat1(doc)
        # record = Record.update_or_create(patient_data)
        # @test_patient_from_qrda= PatientFinder::PatientFromQRDA.new(QRDA1_PATIENT_FILE, record)
    end
    
end