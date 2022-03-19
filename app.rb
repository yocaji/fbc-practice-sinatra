# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'rack/utils'
require 'json'
require 'securerandom'
require_relative 'notebook'

APP_NAME = 'My Memo'

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
  @app = APP_NAME
  @notes = notebook.all
  erb :list
end

# 新規作成
get '/notes/new' do
  @app = APP_NAME
  erb :new
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
    @app = APP_NAME
    @note = target_note
    erb :detail
  else
    erb :status404, layout: false
  end
end

# 編集
get '/notes/:id/edit' do
  id = params[:id]

  notebook = Notebook.new
  target_note = notebook.pick_note(id)
  if target_note
    @app = APP_NAME
    @note = target_note
    erb :edit
  else
    erb :status404, layout: false
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
    erb :status404, layout: false
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
    erb :status404, layout: false
  end
end

not_found do
  status 404
  erb :status404, layout: false
end
