require 'io/console'
require './RbWiringOP/wiring.rb'

def print_help
    puts <<EOF
help        print this help
out <pin>   set the pin as an output pin
in <pin>    set the pin as an input pin
hi <pin>    set the pin to high
lo <pin>    set the pin to low
reset       reset all the pins
quit        quit the script and reset all the pins
EOF
end

at_exit do
	WiringOP.reset
end

# command parser
class Parser
    def initialize
			@pins = []
    end

    def parse string
        #params = []
        params = string.split
        command = params.shift
        exec command, params
    end

    def exec command, params
        case command
        when "help"
            print_help
        when "out"
            pin_no = params[0].to_i
            begin
                @pins[pin_no] = WiringOP::Pin.new :pin => pin_no, :direction => :out
            rescue
                puts "error"
            end
        when "in"
            pin_no = params[0].to_i
            begin
                @pins[pin_no] = WiringOP::Pin.new :pin => pin_no, :direction => :in
            rescue
                puts "error"
            end
        when "hi"
            pin_no = params[0].to_i
            @pins[pin_no].set_hi
        when "lo"
            pin_no = params[0].to_i
            @pins[pin_no].set_lo
        when "reset"
            WiringOP.reset
				when "quit"
					exit
        else
            puts "bad command"
        end
    end
end

p = Parser.new

puts "enter 'help' for help"

loop do 
    print '>'
    p.parse gets.chomp
end
