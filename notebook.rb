# frozen_string_literal: true

require 'pg'

class Notebook
  def initialize
    @conn = PG.connect(dbname: 'mymemo')
    @conn.field_name_type = :symbol
  end

  def all
    @conn.exec('select * from notes').to_a
  end

  def pick_note(id)
    @conn.exec("select * from notes where id = #{id}").to_a[0]
  end

  def add_note(title:, text:)
    result = @conn.exec("insert into notes (title, text) values ('#{title}', '#{text}') returning id").to_a[0]
    result[:id]
  end

  def update_note(id:, title:, text:)
    @conn.exec("update notes set title = '#{title}', text = '#{text}' where id = #{id}")
  end

  def remove_note(id)
    @conn.exec("delete from notes where id = #{id}")
  end
end
