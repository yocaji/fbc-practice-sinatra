# frozen_string_literal: true

require 'json'
require 'securerandom'

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
