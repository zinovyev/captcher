module Helpers
  extend self

  def save_image(image_data, path)
    f = File.new(path, encoding: "ascii-8bit", mode: "w")
    f.binmode
    f.write(image_data)
    f.close
  end

  def create_tmp_dir(options = {})
    remove_tmp_dir if options[:remove]
    Dir.mkdir(tmp_dir) unless File.exist?(tmp_dir)
  end

  def remove_tmp_dir
    FileUtils.rm_rf(tmp_dir)
  end

  def tmp_dir
    @tmp_dir ||= Captcher::Engine.root.join("spec/tmp")
  end
end
