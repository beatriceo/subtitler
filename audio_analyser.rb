class AudioAnalyser
  def self.scrape
    silence_info = ARGV[0]
    text = File.read(silence_info)
    info = text.scan(/(silence_.+\:\s(?<end>\d.\d+).?\|)|(silence_.+\:\s(?<start_duration>\d.+)\s)/)
    hash = {}
    silence_info = []
    info.each_with_index do |i, index|
      i = i.compact[0].to_f
      case index % 3
      when 0
        hash = {}
        hash[:start_time] = i
      when 1 then hash[:end_time] = i
      else
        hash[:duration] = i
        silence_info << hash
      end
    end
    silence_info
  end

  def self.generate_audio_clips
    silence_info = scrape
    silence_info.each_with_index do |slice, index|
      if index + 1 < silence_info.length
        system "ffmpeg -ss #{slice[:end_time] - 0.25} -t #{silence_info[index + 1][:start_time] - slice[:end_time] + 0.25} -i output-audio.aac audio_slices/slice_#{index}.aac"
      end
    end
  end
end

# AudioAnalyser.generate_audio_clips
