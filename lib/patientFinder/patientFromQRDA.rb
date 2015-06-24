#a simple patient from QRDA - contains the source files name and the parsed record associated
module PatientFinder
    class PatientFromQRDA

        #has a filename (the source file name) and a health-data-standards parsed record
        attr_accessor :fileName, :record
        def initialize(fileName, record)
            @fileName=fileName
            @record=record
        end
    end
end

