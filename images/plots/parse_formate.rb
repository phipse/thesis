#!/usr/bin/env ruby

class ParseFormat_

  def initialize()
    @commentSymb = "% "
  end
  
  def isText?( line )
    line.match(/[[:alpha:]]/) != nil || line.match('%') != nil

  end
  
  def isNumber?( line )
    line.match(/[[:digit:]]/) != nil
  end

  def makeComment( line )
    if isText?(line)
      return line = @commentSymb + line
    end
  end

  def us2s(s)
    return (s/1000.0/1000).round(6)
  end
  
  def splitNumberLine( line )
    res = ""
    if isNumber?(line)
      for ele in line.split(",")
	if(isNumber?(ele))
	  res = res + us2s(ele.lstrip.to_i).to_s + ",\n"
	end
      end
    end
    return res
  end

end


if __FILE__ == $0
  puts "parsing #{ARGV[0]}"

  pf = ParseFormat_.new

  outFile = File.open(ARGV[1], "w+")

  File.open(ARGV[0]) do |f|
    while( line = f.gets)
      
      if pf.isText?(line) 
      #puts line
	comment = pf.makeComment(line)
	outFile.write(comment)
      elsif pf.isNumber?(line)
	numbers = pf.splitNumberLine(line)
	outFile.write(numbers)
      end
    end
  end

  outFile.close
end

