class ExcelSheetsController < ApplicationController
  def index
    @excel_sheets=ExcelSheet.all(:order=>'anno,numseq')
  end
end
