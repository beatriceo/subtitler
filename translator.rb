require 'google/cloud/speech'
require 'json'

class Translator
  def self.translate(audio_file_path)
    # p audio_file_path
    # credentials = get_credentials
    speech = Google::Cloud::Speech.new

    # system "gcloud ml speech recognize #{audio_file_path} --language-code='en-US' > responses/#{audio_file_path.gsub(/audio_slices\//, '').gsub(/\.flac/, '')}.json"

    audio_file = File.binread audio_file_path
    config     = { encoding:          :FLAC,
                   sample_rate_hertz: 16000,
                   language_code:     'en-US' }
    audio      = { content: audio_file }

    response = speech.recognize config, audio

    results = response.results

    alternatives = results.first.alternatives
    alternatives.each do |alternative|
      puts "Transcription: #{alternative.transcript}"
    end
  end

  def self.get_credentials
    value = File.read('credentials.json')
    JSON.parse(value)
  end
end
