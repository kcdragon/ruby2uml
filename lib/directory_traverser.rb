require 'find'

class DirectoryTraverser
  def initialize command, include=/.*/, verbose=false, out=$stdout, err=$stderr
    @command = command
    @include = include
    @verbose = verbose
    @out = out
    @err = err
  end

  def process *paths, &block
    paths.each do |path|
      if FileTest.directory? path
        process_dir path, &block
      elsif FileTest.file? path
        process_file path, &block unless path.match(@include).nil? # only process file if it matches @include
      else
        raise "#{path} must be a directory or file"
      end
    end
  end

  private
  def process_dir dir, &block
    @out.puts "entering #{dir}" if @verbose
    Find.find dir do |path|
      process path, &block unless path == dir
    end
  end

  def process_file file, &block
    @out.puts "generating log for #{file}" if @verbose

    #begin
      result = @command.call file
    #  @out.puts "failed to generate log, trying again" if $? != 0
    #end while $? != 0
    
    yield file, result
  end
end
