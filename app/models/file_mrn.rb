require_relative '../../lib/patientFinder/mRNfinder.rb'
class FileMrn
  include Mongoid::Document
  field :file_name, type: String
  field :mrn, type: String
  field :_id, type: String, default: ->{ file_name }


  def self.import(file)

    #instantiate with an collection archived collection of QRDA1 files
    if (!file.nil?)
      patient_finder = PatientFinder::MRNfinder.new(file)

      #process the records and retrive original MRNs
      results_hash=patient_finder.get_original_MRNs_for_tests

      #store the fileMRNs
      FileMrn.delete_all
      results_hash.each_pair do |key, value|
        # puts "\"#{key}\"=>\"#{value}\","
        FileMrn.create(file_name: key, mrn: value )
      end
    end
  end
end
