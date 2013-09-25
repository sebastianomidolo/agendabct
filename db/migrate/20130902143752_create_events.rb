class CreateEvents < ActiveRecord::Migration
  def change
    create_table :excel_sheets do |t|
      t.string :title
      t.string :filename
      t.string :anno
      t.integer :numseq
    end
    create_table(:event_attributes, :id=>false) do |t|
      t.integer :event_id
      t.string :attribute_label
      t.string :content_class
      t.text :content
    end
    create_table :venues do |t|
      t.string :name
    end
    create_table :events do |t|
      t.integer :excel_sheet_id
      t.string :excel_source
      t.text   :title
      t.text   :description
      t.text   :extra_description
      t.integer :venue_id
    end
  end
end
