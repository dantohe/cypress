require_relative '../../utils.rb'
require_relative '../../patientFromQRDA.rb'
require 'minitest/autorun'

class TestUtils <  Minitest::Test
    #this is a bit dummy given the class functionality

    def test_get_master_records_from_cypress
        assert_equal(56,  @master_records.length)
    end

    def test_get_MRNs
        assert_equal(@expected_file_to_MRN_hash, PatientFinder::Utils.get_MRNs( @master_records, @test_patients))
    end

    def test_get_MRN_for_ambiguous
        ambiguous_candidates = ["7a86cc6d87cb84461ea190e7c706d81b", "258ee9087c5a5fe359ceb3aafff0dd76"]
        assert_equal("258ee9087c5a5fe359ceb3aafff0dd76", PatientFinder::Utils.get_MRN_for_ambiguous(ambiguous_candidates))
    end

    def test_get_candidates_for_test
        assert_equal(["61aa020431420dce8f53b74352a990fe"], PatientFinder::Utils.get_candidates_for_test(@master_records,@test_patient_from_qrda.record).map(&:medical_record_number))
    end

    def setup
        @qrda1_file = "test/fixtures/artifacts/0_Hazel_Abbott.xml"
        xml = File.open("test/fixtures/artifacts/0_Hazel_Abbott.xml","r") do |f| f.read() end
        doc = Nokogiri::XML(xml)
        doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
        doc.root.add_namespace_definition('sdtc', 'urn:hl7-org:sdtc')
        patient_data = HealthDataStandards::Import::Cat1::PatientImporter.instance.parse_cat1(doc)
        record = Record.update_or_create(patient_data)
        @master_records = PatientFinder::Utils.get_master_records_from_cypress
        @test_patient_from_qrda= PatientFinder::PatientFromQRDA.new( @qrda1_file, record)
        @test_patients = [@test_patient_from_qrda]
        @expected_file_to_MRN_hash = {"test/fixtures/artifacts/0_Hazel_Abbott.xml" => "61aa020431420dce8f53b74352a990fe"}
    end

end