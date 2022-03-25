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
    query = 'select * from notes where id = $1'
    params = [id]
    execute(query, params).to_a[0]
  end

  def add_note(title:, text:)
    query = 'insert into notes (title, text) values ($1, $2) returning id'
    params = [title, text]
    result = execute(query, params).to_a[0]
    result[:id]
  end

  def update_note(id:, title:, text:)
    query = 'update notes set title = $1, text = $2 where id = $3'
    params = [title, text, id]
    execute(query, params)
  end

  def remove_note(id)
    query = 'delete from notes where id = $1'
    params = [id]
    execute(query, params)
  end

  private

  def execute(query, params = [])
    @conn.exec_params(query, params)
  end
end
