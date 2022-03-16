# frozen_string_literal: true

require 'sinatra'
require 'rack/utils'
require 'json'
require 'securerandom'

APP_NAME = 'My Memo'
STORAGE = './data/data.json'

configure do
  set :method_override, true
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  # 'Root'
  files.to_s
end
# 一覧
get '/notes' do
  @json = File.open(STORAGE).read
  @data = JSON.parse(@json, symbolize_names: true)
  erb :list, locals: { app: APP_NAME, data: @data }
end
# 新規作成
get '/notes/new' do
  erb :new, locals: { app: APP_NAME }
end
post '/notes/new' do
  @title = h(params[:title])
  @text = h(params[:text])
  @json = File.open(STORAGE).read
  @data = JSON.parse(@json, symbolize_names: true)
  @data.push({ id: SecureRandom.hex(8), title: @title, text: @text })
  File.open(STORAGE, 'w') { |file| JSON.dump(@data, file) }
  redirect to '/notes'
end
# 詳細
get '/notes/:id' do
  @id = params[:id]
  @json = File.open(STORAGE).read
  @data = JSON.parse(@json, symbolize_names: true)
  @note = @data.find { |note| note[:id] == @id }
  erb :detail, locals: { app: APP_NAME, note: @note }
end
# 編集
get '/notes/:id/edit' do
  @id = params[:id]
  @json = File.open(STORAGE).read
  @data = JSON.parse(@json, symbolize_names: true)
  @note = @data.find { |note| note[:id] == @id }
  erb :edit, locals: { app: APP_NAME, note: @note }
end
patch '/notes/:id' do
  @id = params[:id]
  @title = h(params[:title])
  @text = h(params[:text])
  @json = File.open(STORAGE).read
  @data = JSON.parse(@json, symbolize_names: true)
  @data = @data.delete_if { |note| note[:id] == @id }
  @data.push({ id: @id, title: @title, text: @text })
  File.open(STORAGE, 'w') { |file| JSON.dump(@data, file) }
  redirect to "/notes/#{@id}"
end
# 削除
delete '/notes/:id' do
  @id = params[:id]
  @json = File.open(STORAGE).read
  @data = JSON.parse(@json, symbolize_names: true)
  @data = @data.delete_if { |note| note[:id] == @id }
  File.open(STORAGE, 'w') { |file| JSON.dump(@data, file) }
  redirect to '/notes'
end

not_found do
  '404 Not Found'
end
