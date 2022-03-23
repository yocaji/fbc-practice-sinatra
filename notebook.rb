# frozen_string_literal: true

require 'pg'

class Notebook
  def initialize
    @conn = PG.connect(dbname: 'mymemo')
    @conn.field_name_type = :symbol
  end

  def all
    query = 'select * from notes'
    execute(query).to_a
  end

  def pick_note(id)
    query = "select * from notes where id = #{id}"
    execute(query).to_a[0]
  end

  def add_note(title:, text:)
    query = "insert into notes (title, text) values ('#{title}', '#{text}') returning id"
    result = execute(query).to_a[0]
    result[:id]
  end

  def update_note(id:, title:, text:)
    query = "update notes set title = '#{title}', text = '#{text}' where id = #{id}"
    execute(query)
  end

  def remove_note(id)
    query = "delete from notes where id = #{id}"
    execute(query)
  end

  private

  def execute(query)
    @conn.exec(query)
  end
end
