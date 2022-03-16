# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require 'rack'
require 'json'
require 'securerandom'

class NoteApp < Sinatra::Base
  APP_NAME = 'メモアプリ'
  configure do
    set :method_override, true
  end
  configure :development do
    register Sinatra::Reloader
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
    @json = File.open('./data/data.json').read
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
    @json = File.open('./data/data.json').read
    @data = JSON.parse(@json, symbolize_names: true)
    @data.push({ id: SecureRandom.hex(8), title: @title, text: @text })
    File.open('./data/data.json', 'w') { |file| JSON.dump(@data, file) }
    redirect to '/notes'
  end
  # 詳細
  get '/notes/:id' do
    @id = params[:id]
    @json = File.open('./data/data.json').read
    @data = JSON.parse(@json, symbolize_names: true)
    @note = @data.find { |note| note[:id] == @id }
    erb :detail, locals: { app: APP_NAME, note: @note }
  end
  # 編集
  get '/notes/:id/edit' do
    @id = params[:id]
    @json = File.open('./data/data.json').read
    @data = JSON.parse(@json, symbolize_names: true)
    @note = @data.find { |note| note[:id] == @id }
    erb :edit, locals: { app: APP_NAME, note: @note }
  end
  patch '/notes/:id' do
    @id = params[:id]
    @title = h(params[:title])
    @text = h(params[:text])
    @json = File.open('./data/data.json').read
    @data = JSON.parse(@json, symbolize_names: true)
    @data = @data.delete_if { |note| note[:id] == @id }
    @data.push({ id: @id, title: @title, text: @text })
    File.open('./data/data.json', 'w') { |file| JSON.dump(@data, file) }
    redirect to "/notes/#{@id}"
  end
  # 削除
  delete '/notes/:id' do
    @id = params[:id]
    @json = File.open('./data/data.json').read
    @data = JSON.parse(@json, symbolize_names: true)
    @data = @data.delete_if { |note| note[:id] == @id }
    File.open('./data/data.json', 'w') { |file| JSON.dump(@data, file) }
    redirect to '/notes'
  end

  not_found do
    '404 Not Found'
  end
end

NoteApp.run!
