# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'

class NoteApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  files = [
    {
      id: '123',
      title: 'メモ１',
      text: 'メモの内容１'
    },
    {
      id: '124',
      title: 'メモ２',
      text: 'メモの内容２'
    }
  ]
  APP_NAME = 'メモアプリ'
  get '/' do
    'Root'
  end
  # 一覧
  get '/notes' do
    erb :list, locals: { app: APP_NAME, files: files }
  end
  # 新規作成
  get '/notes/new' do
    erb :new, locals: { app: APP_NAME }
  end
  post '/notes/new' do
    '新規作成'
  end
  # 詳細
  get '/notes/:id' do
    @id = params[:id]
    @file = files.find { |file| file[:id] == @id }
    erb :detail, locals: { app: APP_NAME, file: @file }
  end
  # 編集
  get '/notes/:id/edit' do
    @id = params[:id]
    @file = files.find { |file| file[:id] == @id }
    erb :edit, locals: { app: APP_NAME, file: @file }
  end
  patch '/notes/:id' do
    @id = params[:id]
    @file = files.find { |file| file[:id] == @id }
    '更新'
  end
  # 削除
  delete '/notes/:id' do
    @id = params[:id]
    @file = files.find { |file| file[:id] == @id }
    '削除'
  end
end

NoteApp.run!
