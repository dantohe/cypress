require_relative '../../mRNfinder.rb'
require 'minitest/autorun'

class TestPatientFinder <  Minitest::Test

    def test_constructor
        assert_equal(@mrn_finder.test_archive, "test/fixtures/artifacts/test_QRDA_files.zip")
    end

    def test_get_original_MRNs_for_tests_1
        assert_equal(@mrn_finder.get_original_MRNs_for_tests, @results_for_zip)
    end

    def setup

        @mrn_finder=PatientFinder::MRNfinder.new("test/fixtures/artifacts/test_QRDA_files.zip")

        @results_for_zip = {"0_Hazel_Abbott.xml" => "61aa020431420dce8f53b74352a990fe",
                        "3_Ana_Barton.xml" => "929dd1f2c4c54c024fd4d18b1307fdb1",
                        "20_Seth_Harper.xml" => "258ee9087c5a5fe359ceb3aafff0dd76",
                        "26_Shawn_Maxwell.xml" => "5f118631f09abdbdeb1962dc28bfeb27",
                        "34_Marie_Stewart.xml" => "fed089904c10b81c036adddedddebe7b"}
    end
end