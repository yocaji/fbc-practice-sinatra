# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'rack/utils'
require 'json'
require 'securerandom'
require_relative 'notebook'

APP_NAME = 'My Memo'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def pick_note(id)
    notebook = Notebook.new
    note = notebook.pick_note(id)
    halt 404 unless note
    note
  end
end

# 一覧
get '/notes' do
  notebook = Notebook.new
  @app = APP_NAME
  @notes = notebook.all
  erb :list
end

# 新規作成
get '/notes/new' do
  @app = APP_NAME
  erb :new
end

post '/notes' do
  title = params[:title]
  text = params[:text]
  notebook = Notebook.new
  id = notebook.add_note(title: title, text: text)
  redirect to "/notes/#{id}"
end

# 詳細
get '/notes/:id' do
  id = params[:id]
  @app = APP_NAME
  @note = pick_note(id)
  erb :detail
end

# 編集
get '/notes/:id/edit' do
  id = params[:id]
  @app = APP_NAME
  @note = pick_note(id)
  erb :edit
end

patch '/notes/:id' do
  id = params[:id]
  title = params[:title]
  text = params[:text]
  pick_note(id)
  notebook = Notebook.new
  notebook.remove_note(id)
  notebook.add_note(title: title, text: text, id: id)
  redirect to "/notes/#{id}"
end

# 削除
delete '/notes/:id' do
  id = params[:id]
  pick_note(id)
  notebook = Notebook.new
  notebook.remove_note(id)
  redirect to '/notes'
end

not_found do
  status 404
  erb :status404, layout: false
end
