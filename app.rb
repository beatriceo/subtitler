require_relative 'translator'

# Translate each audio file
Dir.glob('audio_slices/*.flac').each do |audio_file|
  Translator.translate(audio_file)
end
