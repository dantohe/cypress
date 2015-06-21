class FileMrnsController < ApplicationController
  def index
    @fileMRNs= FileMrn.all
  end

  def import
    FileMrn.import(params[:file])
    redirect_to file_mrns_url , notice: "Zip imported."
  end
end
