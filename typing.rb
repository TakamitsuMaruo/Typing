require "dxruby"
require_relative "key.rb"
require_relative "font.rb"

class Word
	attr_accessor :japanese,:pronounce
	def initialize(japanese,pronounce)
		self.japanese = japanese
		self.pronounce = pronounce
	end
end

words = []
num = 0
font_height = 50
frame = 60

File.open("./words.txt","r") do |f|
	while (line = f.gets)
		next if line[0] == '#'
		line = line.split(",")
		words << Word.new(line[0],line[1])
		num += 1
	end
end

if $fontpath != ""
	fontname = Font.install($fontpath)
	font = Font.new(font_height,fontname[0])
else
	font = Font.new(font_height)
end

word = words[rand(0...num)]
n = 0

Window.loop do
	if frame == 60
		Window.drawFont(0,0,word.japanese.encode,font)
		Window.drawFont(0,font_height,word.pronounce[0...n],font,color: C_GREEN)
		Window.drawFont(font.get_width(word.pronounce[0...n]),font_height,word.pronounce[n...word.pronounce.length],font,color: C_WHITE)
		n += 1 if (Input.keys.shift == $key[word.pronounce[n].ord - 'A'.ord] || (word.pronounce[n] == "-" && Input.keys.shift == 12))
		if (n == word.pronounce.length-1)
			n = 0
			word = words[rand(0...num)]
			frame = 0
		end
	else
		frame += 1
	end
	Window.drawFont(0,480-font_height*2,"Escapeで終了",font)
	Window.drawFont(0,480-font_height,"使用中のフォント:#{font.name.encode(Encoding::UTF_8)}",font)
	exit if (Input.keyPush?(K_ESCAPE))
end
