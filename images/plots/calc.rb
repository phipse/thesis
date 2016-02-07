#!/usr/bin/env ruby

class SumMinMax

  def initialize(min = 1000000000, max = 0, sum = 0, cnt = 0)
    @min = min
    @max = max
    @max2 = max
    @sum = sum
    @cnt = cnt
    @arr = []
    @musFactor = 1000 * 1000.0
  end

  def summinmax(input)
    @sum += input
    if input < @min
      @min = input
    end
    if input > @max
      @max2 = @max
      @max = input
    elsif input > @max2
      @max2 = input
#      puts "Max #{@max}  #{@max2}"
    end
    @arr[@cnt] = input
    @cnt += 1
  end

  def median
    # compute n-tieth percentile
    percentile = (9*@arr.length / 10.0).round
    return @arr.sort.at(percentile)
    #(@arr.sort.at((@arr.length/2.0).round))
  end

  def getAvgInS
    return (@sum/@cnt)
  end

  def mus2s
    @mins = @min/@musFactor
    @maxs = @max/@musFactor
    @max2s = @max2/@musFactor
  end

  def getMinMax
    return @min, @max
  end
  
  def printResults(name)
    if @cnt != 0
      precision = 6
      #mus2s()
      avg = (@sum/@cnt)
      name2 = name + "1"
      rminsAvg = (avg-@min).round(precision)
      rmaxsAvg = (@max-avg).round(precision)
      median = median()
      rminsMed = (median-@min).round(precision)
      rmaxsMed = (@max-median).round(precision)

      return "% Format: name, avg, median, minAvg, maxAvg, minMed, maxMed, Elements\n\
name avg median minAvg maxAvg minMed maxMed Elements\n\
#{name} #{avg} #{median} #{rminsAvg} #{rmaxsAvg} #{rminsMed} #{rmaxsMed} #{@cnt}\n"
# #{name2} #{avg} #{median} #{rmins} #{rmax2s} #{@cnt-1}\n"
    end
  end
end


class PlotterGen

  def initialize(skeleton )
    @skeletonFile = skeleton
    @min = 0
    @max = 0
    @avg = 0
    @filename = ""
  end

  def setAvg(avg)
    @avg =avg
  end

  def minMaxString(str)
    spl = str.split(" ")
    for s in spl
      minmax = s.match('\[(\d)*\|(\d)*\]')
      if minmax != nil
	minmax = minmax[0].split('|')
	minmax = minmax.each {|s| s.gsub!(/[\[|\]]/, "")}
#	puts minmax
	@minS = minmax[0].to_i
	@maxS = minmax[1].to_i
	return true
      end
    end
    return false;
  end

  def avgString(str)
    avgMatch = str.match('Average: (\d)+')
    if avgMatch != nil
      avg = avgMatch[0].match('(\d)+')
      if avg != nil
	@avg = avg[0].to_i
	@avg = us2s(@avg)
      end
    end
  end

  def us2s(us)
    return (us / 1000.0 / 1000)
  end

  def s2us(s)
    return (s * 1000 * 1000 ).to_i
  end

  def round_down(fl, prec)
    return prec < 1 ? fl.to_i.to_f : (fl - 0.5 / 10**prec).round(prec)
  end
    
  def round_up(fl, prec)
    return prec < 1 ? fl.to_i.to_f : (fl + 0.5 / 10**prec).round(prec)
  end

  def roundDistance
    if (@max - @maxS) < 0.1 
      @max += 0.1
    end
    if (@minS - @min) < 0.1
      @min -= 0.1
    end
  end

  def parseMinMax( str )
    # test if min max is present
    if minMaxString(str) == true
      # min max found, round to seconds with precision one.
      @min = round_down( us2s(@minS), 1)
      @max = round_up(us2s(@maxS), 1)
      if @min == @max
	@max = @max + 0.5
	@min = @min - 0.5
      end
      roundDistance()
#      @min = s2us(@min)
#      @max = s2us(@max)
    end
    avgString(str)
  end

  def isTex(filename)
    return filename.split(".").last.eql?("tex")
  end

  def setMinMax(min, max)
    @min = round_down(min,1)
    @max = round_up(max,1)
  end

  def writeTex(datafile, outputfile)
#    if isTex == false then return end

    fo = File.open(outputfile, 'w+')
    fi = File.open(@skeletonFile, 'r')

    title = datafile.split('_').first

    while(inLine = fi.gets)
      inLine = inLine.gsub(/\$XMIN/, @min.to_s)
      inLine = inLine.gsub(/\$XMAX/, @max.to_s)
      inLine = inLine.gsub(/\$DATAFILENAME/, datafile)
      inLine = inLine.gsub(/\$NAME/, title)
      inLine = inLine.gsub(/\$AVG/, @avg.to_s)
      fo.write(inLine)
    end

    fi.close
    fo.close
  end

end


if __FILE__ == $0
#  puts "calculating avg min max for #{ARGV[0]}"
  avg = SumMinMax.new
  plot = PlotterGen.new("plot_skeleton.tex")

  File.open(ARGV[0]) do |f|
    while( line = f.gets)
      # test for comment line
      if( line.lstrip.start_with?('%') ) 
	plot.parseMinMax(line)
      else

	# strip all left white spaces: lstrip
	# remove trailing newline, but no character: chomp
	arr = line.split(',').map! {|s| s.lstrip.chomp}
#	puts line
	#puts arr[0]
#	puts arr.length

	avg.summinmax(arr[0].to_f)
#	arr.each {|num| avg.summinmax(num.to_f)}
      end
    end
  end
  
  # write to file
  fn = ARGV[0] + "_result"
  texfile = ARGV[0] + "_plot.tex"

  plot.setAvg(avg.getAvgInS())
  min, max = avg.getMinMax()
  plot.setMinMax(min, max)

  plot.writeTex(ARGV[0], texfile)

  # get test name 
  name = fn.split('_').first.split('/').last
#  puts avg.printResults(name)

  File.open(fn, 'w+') { |f| f.write( avg.printResults( name )) }
end
