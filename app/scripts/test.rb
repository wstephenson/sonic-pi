#!/usr/bin/env ruby
require_relative "core.rb"

require_relative "sonicpi/scsynth"
require_relative "sonicpi/studio"
require_relative "sonicpi/spider"
require_relative "sonicpi/server"
require_relative "sonicpi/util"
require_relative "sonicpi/rcv_dispatch"

#Thread.abort_on_exception=true

include SonicPi::Util

ws_out = Queue.new
$scsynth = SonicPi::SCSynth.instance

$c = OSC::Client.new("localhost", 4556)
$c.send(OSC::Message.new("/d_loadDir", synthdef_path))
sleep 2

$sp =  SonicPi::Spider.new "localhost", 4556, ws_out, 5

$rd = SonicPi::RcvDispatch.new($sp, ws_out)
$clients = []

# Send stuff out from Sonic Pi jobs out to GUI
out_t = Thread.new do
  continue = true
  while continue
    begin
      message = ws_out.pop
      message[:ts] = Time.now.strftime("%H:%M:%S")

      if message[:type] == :exit
        continue = false
      else
        puts message
      end
    rescue Exception => e
      puts "Exception!"
      puts e.message
      puts e.backtrace.inspect
    end
  end
end

Thread.new do
  f = File.open("/tmp/gc.txt", 'w')
  loop do
    f.puts GC.stat
    f.flush
    sleep 2
  end
end

def test_simple
  $rd.dispatch({:cmd => "run-code",
                :val => "play 60"})
end

def test_multi_osc
  $rd.dispatch({:cmd => "run-code",
                :val => "loop do ; status ; sleep 0.025 ; end"})
end

def test_multi_play
  $rd.dispatch({:cmd => "run-code",
                :val => "loop do ; play 60 ; sleep 0.025 ; end"})
end

def test_multi_threads
  $rd.dispatch({:cmd => "run-code",
                :val => "loop do ; in_thread do ; play 60 ; sleep 3 ; end ; sleep 0.025 ; end"})
end

def test_multi_jobs
  loop do
    $rd.dispatch({:cmd => "run-code",
                  :val => "play 60"})
    sleep 0.025
  end
end

def test_exception_throwing
  loop do
    $rd.dispatch({:cmd => "run-code",
                  :val => "play 60 ; 1/0"})
    sleep 0.025
  end
end

def test_exception_throwing_within_subthread
  loop do
    $rd.dispatch({:cmd => "run-code",
                  :val => "play 60 ; in_thread do ; 1/0 ; end"})
    sleep 0.025
  end
end

test_multi_play

at_exit do
  $c.send(OSC::Message.new("/quit"))
end


out_t.join
