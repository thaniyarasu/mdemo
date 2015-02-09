class Invite < ActiveRecord::Base
  mount_uploader :document, DocumentUploader

  validates :name ,:document ,presence: true

  attr_accessor :parser

  def parser
    return @parser if @parser

    doc = self.document
    case doc.file.extension
      when "xlsx" then
        @parser = Roo::Excelx.new(doc.path)
      when "xls" then
        @parser = Roo::Spreadsheet.open(doc.path)
      when "csv" then
        @parser = Roo::CSV.new(doc.path)
      when "ods" then
      when "tsv" then
    end
    return @parser
  end

  def parse(key="email",ids=[])
    return [] if ids.empty?
    keys = []
    parser.sheets.each_with_index do |n,i|
      s = parser.sheet(i)
      row0 = s.row(s.first_row)
      index = row0.find_index {|e| e=~ /#{key}/i}
      return [] if index.nil?
      count = 0
      (s.first_row+1).upto(s.last_row) do |e|
        count += 1
        keys << s.row(e)[index] if ids.include?(count)
      end
    end
    keys
  end

end



