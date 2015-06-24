require_relative '../../mRNfinder.rb'
require 'minitest/autorun'

class TestPatientFinder <  Minitest::Test

    def test_constructor
        assert_equal(@mrn_finder_1.test_archive, "test/fixtures/artifacts/T63-21.zip")
    end

    def test_get_original_MRNs_for_tests_1
        assert_equal(@mrn_finder_1.get_original_MRNs_for_tests, @results_for_ZIP_FILE_T63_21)
    end

    def test_get_original_MRNs_for_tests_2
        assert_equal(@mrn_finder_2.get_original_MRNs_for_tests, @results_for_ZIP_FILE_T63_22)
    end

    def test_get_original_MRNs_for_tests_3
        assert_equal(@mrn_finder_3.get_original_MRNs_for_tests, @results_for_ZIP_FILE_T63_23)
    end

    def test_get_original_MRNs_for_tests_4
        assert_equal(@mrn_finder_4.get_original_MRNs_for_tests, @results_for_ZIP_FILE_T63_24)
    end


    def setup

        @mrn_finder_1=PatientFinder::MRNfinder.new("test/fixtures/artifacts/T63-21.zip")
        @mrn_finder_2=PatientFinder::MRNfinder.new("test/fixtures/artifacts/T63-22.zip")
        @mrn_finder_3=PatientFinder::MRNfinder.new("test/fixtures/artifacts/T63-23.zip")
        @mrn_finder_4=PatientFinder::MRNfinder.new("test/fixtures/artifacts/T63-24.zip")

        @results_for_ZIP_FILE_T63_21 = {"0_Hazel_Abbott.xml" => "61aa020431420dce8f53b74352a990fe",
                        "1_Ruth_Baker.xml" => "343731b99c6bdb35a1fc31ce9ed6f889",
                        "2_Darryl_Barnes.xml" => "7a86cc6d87cb84461ea190e7c706d81b",
                        "3_Ana_Barton.xml" => "929dd1f2c4c54c024fd4d18b1307fdb1",
                        "4_Julie_Boone.xml" => "5407e0ea5126420644b503c66153eb3c",
                        "5_Ross_Brock.xml" => "5f118631f09abdbdeb1962dc28bfeb27",
                        "6_Philip_Casey.xml" => "185be4f0c1ea87f63e4326e45db87bdf",
                        "7_Leroy_Cohen.xml" => "a6300c43651965991a4308ffaeb5381d",
                        "8_Evelyn_Conner.xml" => "0a26a978d07240b0f917e96727db31d8",
                        "9_Nathan_Cross.xml" => "20a80b26a1bfa70740e243ea5ac1fea6",
                        "10_Josephine_Dean.xml" => "d045df54952043573bb6a94c374c8420",
                        "11_Sonia_Ellis.xml" => "ee85c89f24946e2ddca12c6edc5181dc",
                        "12_Delores_Fletcher.xml" => "29cecb1da08efd331fce823e12b607d5",
                        "13_Lydia_Ford.xml" => "fdea0c22270417d9e59f20b07f642679",
                        "14_Jeanette_Fowler.xml" => "d156a6d38e10efc30eda3cace7456537",
                        "15_Gary_Fox.xml" => "cce1bd3b83676d7a9b286b374b4c34f8",
                        "16_Sara_Garner.xml" => "88130abfa702d8f53ac7be76e9d24a58",
                        "17_Jeanette_Greer.xml" => "846c1c2ba8370c2f5504b315cc4b1d5d",
                        "18_Susan_Hanson.xml" => "511b530c8662f8df97eb97b3eefa0618",
                        "19_Lucy_Harmon.xml" => "ee85c89f24946e2ddca12c6edc5181dc",
                        "20_Seth_Harper.xml" => "258ee9087c5a5fe359ceb3aafff0dd76",
                        "21_Tara_Joseph.xml" => "1be81ce59da982792026cc82d95bc10e",
                        "22_Marc_Lawson.xml" => "7a86cc6d87cb84461ea190e7c706d81b",
                        "23_Keith_Logan.xml" => "bd2d8e0fd774e32f623e1fe5ad44781f",
                        "24_Sergio_Lucas.xml" => "0085074bb549ffefffa6e16ff34df140",
                        "25_Joshua_Massey.xml" => "91bd37f9cebf7b6ef9f72d7fd6148a81",
                        "26_Shawn_Maxwell.xml" => "5f118631f09abdbdeb1962dc28bfeb27",
                        "27_April_Mccormick.xml" => "0dbaf9336f7aa1590265250a0eebe548",
                        "28_Wayne_Morris.xml" => "2678a4e396aaec03b860d5aeadcad8e6",
                        "29_Jay_Reese.xml" => "e05ff19bd33566173fd742d4b9831f1f",
                        "30_Billy_Roberson.xml" => "ce83c561f62e245ad4e0ca648e9de0dd",
                        "31_Matthew_Salazar.xml" => "8130b2ff5774f1593c86eba8dca4c37b",
                        "32_Corey_Shelton.xml" => "b5633133e3421216ced2bdef4dbf382d",
                        "33_Georgia_Snyder.xml" => "b54a4e3ab37de7e5f8094793afb8a699",
                        "34_Marie_Stewart.xml" => "fed089904c10b81c036adddedddebe7b",
                        "35_Bruce_Stokes.xml" => "697e147f076648275e518e7b3ff41dcd",
                        "36_Virgil_Sullivan.xml" => "bc8f60f4cbde3d6c28974971b6880792",
                        "37_Eugene_Turner.xml" => "470f57b022eaeffd4d599078e851a56d",
                        "38_Julia_Waters.xml" => "5407e0ea5126420644b503c66153eb3c"}

        @results_for_ZIP_FILE_T63_22 = {"0_Elmer_Austin.xml"=>"b5633133e3421216ced2bdef4dbf382d",
                        "1_Bessie_Bowman.xml"=>"61aa020431420dce8f53b74352a990fe",
                        "2_Nathan_Carson.xml"=>"2678a4e396aaec03b860d5aeadcad8e6",
                        "3_Craig_Chandler.xml"=>"697e147f076648275e518e7b3ff41dcd",
                        "4_Larry_Clark.xml"=>"0085074bb549ffefffa6e16ff34df140",
                        "5_Gregory_Cohen.xml"=>"ce83c561f62e245ad4e0ca648e9de0dd",
                        "6_Erin_Cortez.xml"=>"fdea0c22270417d9e59f20b07f642679",
                        "7_Audrey_Curry.xml"=>"846c1c2ba8370c2f5504b315cc4b1d5d",
                        "8_Vanessa_Elliott.xml"=>"29cecb1da08efd331fce823e12b607d5",
                        "9_Nathan_French.xml"=>"8130b2ff5774f1593c86eba8dca4c37b",
                        "10_Becky_Fuller.xml"=>"ee85c89f24946e2ddca12c6edc5181dc",
                        "11_Seth_Gibson.xml"=>"20a80b26a1bfa70740e243ea5ac1fea6",
                        "12_Lloyd_Graham.xml"=>"a6300c43651965991a4308ffaeb5381d",
                        "13_Keith_Harrington.xml"=>"e05ff19bd33566173fd742d4b9831f1f",
                        "14_Jordan_Hawkins.xml"=>"cce1bd3b83676d7a9b286b374b4c34f8",
                        "15_Bob_Hayes.xml"=>"470f57b022eaeffd4d599078e851a56d",
                        "16_Dolores_Jensen.xml"=>"5407e0ea5126420644b503c66153eb3c",
                        "17_Marsha_Marsh.xml"=>"b54a4e3ab37de7e5f8094793afb8a699",
                        "18_Annette_Mcguire.xml"=>"d045df54952043573bb6a94c374c8420",
                        "19_Elaine_Mclaughlin.xml"=>"929dd1f2c4c54c024fd4d18b1307fdb1",
                        "20_Marjorie_Miles.xml"=>"1be81ce59da982792026cc82d95bc10e",
                        "21_Jon_Miller.xml"=>"470f57b022eaeffd4d599078e851a56d",
                        "22_Derek_Moody.xml"=>"7a86cc6d87cb84461ea190e7c706d81b",
                        "23_Tracy_Moreno.xml"=>"88130abfa702d8f53ac7be76e9d24a58",
                        "24_Lillian_Norton.xml"=>"511b530c8662f8df97eb97b3eefa0618",
                        "25_Hector_Norton.xml"=>"bd2d8e0fd774e32f623e1fe5ad44781f",
                        "26_Salvador_Oliver.xml"=>"91bd37f9cebf7b6ef9f72d7fd6148a81",
                        "27_Fred_Peters.xml"=>"258ee9087c5a5fe359ceb3aafff0dd76",
                        "28_Ida_Pierce.xml"=>"0a26a978d07240b0f917e96727db31d8",
                        "29_Bob_Robinson.xml"=>"185be4f0c1ea87f63e4326e45db87bdf",
                        "30_Martin_Salazar.xml"=>"8130b2ff5774f1593c86eba8dca4c37b",
                        "31_Sam_Sanchez.xml"=>"bc8f60f4cbde3d6c28974971b6880792",
                        "32_Randy_Simmons.xml"=>"5f118631f09abdbdeb1962dc28bfeb27",
                        "33_Geraldine_Simpson.xml"=>"ee85c89f24946e2ddca12c6edc5181dc",
                        "34_Veronica_Stokes.xml"=>"d156a6d38e10efc30eda3cace7456537",
                        "35_Grace_Wade.xml"=>"fed089904c10b81c036adddedddebe7b",
                        "36_Karen_Wade.xml"=>"343731b99c6bdb35a1fc31ce9ed6f889",
                        "37_Derrick_Wagner.xml"=>"7a86cc6d87cb84461ea190e7c706d81b",
                        "38_Felicia_Webb.xml"=>"0dbaf9336f7aa1590265250a0eebe548",
                        "39_Brad_Wheeler.xml"=>"bc8f60f4cbde3d6c28974971b6880792"}

        @results_for_ZIP_FILE_T63_23 = {"0_Erika_Ball.xml"=>"61aa020431420dce8f53b74352a990fe",
                        "1_Terri_Barker.xml"=>"846c1c2ba8370c2f5504b315cc4b1d5d",
                        "2_Shawn_Benson.xml"=>"697e147f076648275e518e7b3ff41dcd",
                        "3_Ashley_Bishop.xml"=>"b54a4e3ab37de7e5f8094793afb8a699",
                        "4_Franklin_Burgess.xml"=>"8130b2ff5774f1593c86eba8dca4c37b",
                        "5_Elsie_Cain.xml"=>"511b530c8662f8df97eb97b3eefa0618",
                        "6_Randy_Christensen.xml"=>"5f118631f09abdbdeb1962dc28bfeb27",
                        "7_Margie_Cortez.xml"=>"29cecb1da08efd331fce823e12b607d5",
                        "8_Curtis_Dawson.xml"=>"258ee9087c5a5fe359ceb3aafff0dd76",
                        "9_Rebecca_Delgado.xml"=>"846c1c2ba8370c2f5504b315cc4b1d5d",
                        "10_Jorge_Ferguson.xml"=>"0085074bb549ffefffa6e16ff34df140",
                        "11_Salvador_Fernandez.xml"=>"b5633133e3421216ced2bdef4dbf382d",
                        "12_Carole_Griffith.xml"=>"ee85c89f24946e2ddca12c6edc5181dc",
                        "13_Ken_Guzman.xml"=>"258ee9087c5a5fe359ceb3aafff0dd76",
                        "14_Carrie_Harris.xml"=>"929dd1f2c4c54c024fd4d18b1307fdb1",
                        "15_Benjamin_Holloway.xml"=>"91bd37f9cebf7b6ef9f72d7fd6148a81",
                        "16_Jill_Jenkins.xml"=>"0a26a978d07240b0f917e96727db31d8",
                        "17_Eddie_Klein.xml"=>"2678a4e396aaec03b860d5aeadcad8e6",
                        "18_Regina_Knight.xml"=>"5407e0ea5126420644b503c66153eb3c",
                        "19_Mary_Lambert.xml"=>"fdea0c22270417d9e59f20b07f642679",
                        "20_Betty_Mason.xml"=>"1be81ce59da982792026cc82d95bc10e",
                        "21_Sally_Moran.xml"=>"ee85c89f24946e2ddca12c6edc5181dc",
                        "22_Jeff_Moreno.xml"=>"7a86cc6d87cb84461ea190e7c706d81b",
                        "23_Vanessa_Morgan.xml"=>"d156a6d38e10efc30eda3cace7456537",
                        "24_Norman_Norton.xml"=>"185be4f0c1ea87f63e4326e45db87bdf",
                        "25_Carla_Obrien.xml"=>"0dbaf9336f7aa1590265250a0eebe548",
                        "26_Todd_Owen.xml"=>"a6300c43651965991a4308ffaeb5381d",
                        "27_Casey_Owens.xml"=>"bd2d8e0fd774e32f623e1fe5ad44781f",
                        "28_Jessica_Payne.xml"=>"fed089904c10b81c036adddedddebe7b",
                        "29_Rafael_Perry.xml"=>"bc8f60f4cbde3d6c28974971b6880792",
                        "30_Ralph_Potter.xml"=>"20a80b26a1bfa70740e243ea5ac1fea6",
                        "31_Lydia_Rowe.xml"=>"0dbaf9336f7aa1590265250a0eebe548",
                        "32_Eleanor_Santiago.xml"=>"d045df54952043573bb6a94c374c8420",
                        "33_Marshall_Shaw.xml"=>"470f57b022eaeffd4d599078e851a56d",
                        "34_Denise_Spencer.xml"=>"fdea0c22270417d9e59f20b07f642679",
                        "35_Willard_Stephens.xml"=>"e05ff19bd33566173fd742d4b9831f1f",
                        "36_Rafael_Underwood.xml"=>"cce1bd3b83676d7a9b286b374b4c34f8",
                        "37_Hazel_Vasquez.xml"=>"88130abfa702d8f53ac7be76e9d24a58",
                        "38_Edgar_Wells.xml"=>"ce83c561f62e245ad4e0ca648e9de0dd",
                        "39_Angel_Wood.xml"=>"91bd37f9cebf7b6ef9f72d7fd6148a81",
                        "40_Ella_Woods.xml"=>"343731b99c6bdb35a1fc31ce9ed6f889"}

        @results_for_ZIP_FILE_T63_24 = {"0_Lucille_Barker.xml"=>"1be81ce59da982792026cc82d95bc10e",
                        "1_Raymond_Becker.xml"=>"b5633133e3421216ced2bdef4dbf382d",
                        "2_Debbie_Boyd.xml"=>"5407e0ea5126420644b503c66153eb3c",
                        "3_Miriam_Bradley.xml"=>"ee85c89f24946e2ddca12c6edc5181dc",
                        "4_Brandon_Casey.xml"=>"697e147f076648275e518e7b3ff41dcd",
                        "5_Jackie_Castro.xml"=>"846c1c2ba8370c2f5504b315cc4b1d5d",
                        "6_Franklin_Clark.xml"=>"e05ff19bd33566173fd742d4b9831f1f",
                        "7_Jeanne_Davis.xml"=>"fdea0c22270417d9e59f20b07f642679",
                        "8_Jane_Delgado.xml"=>"88130abfa702d8f53ac7be76e9d24a58",
                        "9_Tracy_Figueroa.xml"=>"d045df54952043573bb6a94c374c8420",
                        "10_Carla_Fleming.xml"=>"29cecb1da08efd331fce823e12b607d5",
                        "11_Manuel_Frazier.xml"=>"bd2d8e0fd774e32f623e1fe5ad44781f",
                        "12_Warren_Fuller.xml"=>"470f57b022eaeffd4d599078e851a56d",
                        "13_Anne_Gilbert.xml"=>"929dd1f2c4c54c024fd4d18b1307fdb1",
                        "14_Jared_Gonzales.xml"=>"91bd37f9cebf7b6ef9f72d7fd6148a81",
                        "15_Raul_Hines.xml"=>"8130b2ff5774f1593c86eba8dca4c37b",
                        "16_Tracy_Jennings.xml"=>"cce1bd3b83676d7a9b286b374b4c34f8",
                        "17_Josephine_Jennings.xml"=>"b54a4e3ab37de7e5f8094793afb8a699",
                        "18_Debbie_Johnston.xml"=>"61aa020431420dce8f53b74352a990fe",
                        "19_Perry_Jones.xml"=>"7a86cc6d87cb84461ea190e7c706d81b",
                        "20_Harvey_Jordan.xml"=>"258ee9087c5a5fe359ceb3aafff0dd76",
                        "21_Harry_Malone.xml"=>"bc8f60f4cbde3d6c28974971b6880792",
                        "22_Lewis_May.xml"=>"a6300c43651965991a4308ffaeb5381d",
                        "23_Mark_Moore.xml"=>"5f118631f09abdbdeb1962dc28bfeb27",
                        "24_Russell_Moore.xml"=>"ce83c561f62e245ad4e0ca648e9de0dd",
                        "25_Jimmy_Moreno.xml"=>"2678a4e396aaec03b860d5aeadcad8e6",
                        "26_Ellen_Morrison.xml"=>"d045df54952043573bb6a94c374c8420",
                        "27_Clinton_Nichols.xml"=>"0085074bb549ffefffa6e16ff34df140",
                        "28_Guy_Reeves.xml"=>"185be4f0c1ea87f63e4326e45db87bdf",
                        "29_Ann_Robbins.xml"=>"ee85c89f24946e2ddca12c6edc5181dc",
                        "30_Julia_Rowe.xml"=>"d156a6d38e10efc30eda3cace7456537",
                        "31_Harold_Ryan.xml"=>"20a80b26a1bfa70740e243ea5ac1fea6",
                        "32_Joyce_Schneider.xml"=>"0dbaf9336f7aa1590265250a0eebe548",
                        "33_Florence_Simmons.xml"=>"0dbaf9336f7aa1590265250a0eebe548",
                        "34_Mildred_Sparks.xml"=>"fed089904c10b81c036adddedddebe7b",
                        "35_Anne_Stephens.xml"=>"343731b99c6bdb35a1fc31ce9ed6f889",
                        "36_Florence_Stevenson.xml"=>"511b530c8662f8df97eb97b3eefa0618",
                        "37_Claudia_Torres.xml"=>"0a26a978d07240b0f917e96727db31d8",
                        "38_Bobby_Yates.xml"=>"a6300c43651965991a4308ffaeb5381d"}
    end
end