# frozen_string_literal: true

require 'pg'

class Notebook
  DB_NAME = 'mymemo'

  def all
    read_storage
  end

  def pick_note(id)
    read_storage.find { |note| note[:id] == id }
  end

  def add_note(title:, text:)
    conn = PG.connect(dbname: 'mymemo')
    conn.internal_encoding = 'UTF-8'
    conn.field_name_type = :symbol
    result = conn.exec("insert into notes (title, text) values ('#{title}', '#{text}') returning id").to_a[0]
    result[:id]
  end

  def update_note(id:, title:, text:)
    conn = PG.connect(dbname: 'mymemo')
    conn.internal_encoding = 'UTF-8'
    conn.field_name_type = :symbol
    conn.exec("update notes set title = '#{title}', text = '#{text}' where id = #{id}")
  end

  def remove_note(id)
    conn = PG.connect(dbname: 'mymemo')
    conn.internal_encoding = 'UTF-8'
    conn.field_name_type = :symbol
    conn.exec("delete from notes where id = #{id}")
  end

  private

  def read_storage
    conn = PG.connect(dbname: 'mymemo')
    conn.internal_encoding = 'UTF-8'
    conn.field_name_type = :symbol
    conn.exec('select * from NOTES').to_a
  end
end
