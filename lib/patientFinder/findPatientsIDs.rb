#!/usr/bin/ruby
require_relative 'mRNfinder.rb'


if(ARGV.length<1)
    puts "One argument is needed: \n\tthe path to the zip containing the QRDA1 test files"
    puts "Example: \n\tbundle exec ruby findPatientsIDs.rb test/T63-22.zip"
    abort "Abort - missing arguments"
end

#instantiate with an collection archived collection of QRDA1 files
patient_finder = PatientFinder::MRNfinder.new(ARGV[0])

#process the records and retrive original MRNs
results_hash=patient_finder.get_original_MRNs_for_tests

#printing results
results_hash.each_pair do |key, value|
    puts "\"#{key}\"=>\"#{value}\","
end

