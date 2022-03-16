# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'rack/utils'
require 'json'
require 'securerandom'

APP_NAME = 'My Notebook'

class Notebook
  STORAGE = './data/data.json'

  def all
    read_storage
  end

  def add_note(title:, text:, id: SecureRandom.hex(8))
    notes = read_storage.push({ id: id, title: title, text: text })
    File.open(STORAGE, 'w') { |file| JSON.dump(notes, file) }
    id
  end

  def pick_note(id)
    read_storage.find { |note| note[:id] == id }
  end

  def remove_note(id)
    notes = read_storage.delete_if { |note| note[:id] == id }
    File.open(STORAGE, 'w') { |file| JSON.dump(notes, file) }
  end

  private

  def read_storage
    json = File.open(STORAGE).read
    JSON.parse(json, symbolize_names: true)
  end
end

configure do
  set :method_override, true
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

# 一覧
get '/notes' do
  notebook = Notebook.new
  erb :list, locals: { app: APP_NAME, data: notebook.all }
end

# 新規作成
get '/notes/new' do
  erb :new, locals: { app: APP_NAME }
end

post '/notes/new' do
  title = h(params[:title])
  text = h(params[:text])

  notebook = Notebook.new
  id = notebook.add_note(title: title, text: text)
  redirect to "/notes/#{id}"
end

# 詳細
get '/notes/:id' do
  id = params[:id]

  notebook = Notebook.new
  target_note = notebook.pick_note(id)
  if target_note
    erb :detail, locals: { app: APP_NAME, note: target_note }
  else
    erb :status_404, layout: false
  end
end

# 編集
get '/notes/:id/edit' do
  id = params[:id]

  notebook = Notebook.new
  target_note = notebook.pick_note(id)
  if target_note
    erb :edit, locals: { app: APP_NAME, note: target_note }
  else
    erb :status_404, layout: false
  end
end

patch '/notes/:id' do
  id = params[:id]
  title = h(params[:title])
  text = h(params[:text])

  notebook = Notebook.new
  target_note = notebook.pick_note(id)
  if target_note
    notebook.remove_note(id)
    notebook.add_note(title: title, text: text, id: id)
    redirect to "/notes/#{id}"
  else
    erb :status_404, layout: false
  end
end

# 削除
delete '/notes/:id' do
  id = params[:id]

  notebook = Notebook.new
  target_note = notebook.pick_note(id)
  if target_note
    notebook.remove_note(id)
    redirect to '/notes'
  else
    erb :status_404, layout: false
  end
end

not_found do
  status 404
  erb :status_404, layout: false
end
