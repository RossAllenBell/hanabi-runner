require 'terminal-table'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on('-d', '--debug', TrueClass, 'Debug mode') do |v|
    options[:debug] = v
  end

  opts.on('-a', '--agent AGENT', String, 'Single agent') do |v|
    options[:agent] = v
  end

  opts.on('-c', '--count COUNT', Integer, 'Run count') do |v|
    options[:count] = v
  end
end.parse!

puts 'Loading files'
Dir['./lib/**/*.rb'].each {|file| require file }
Dir['./agents/**/*.rb'].each {|file| require file }

puts 'Detecting agent classes'
agent_classes = ObjectSpace.each_object(Class).select { |klass| klass < Agent }.sort_by(&:name)

puts "Agent classes: #{agent_classes.map(&:name).join(', ')}"

DEBUG = options[:debug]
puts 'Debug enabled' if DEBUG

COUNT = options[:count] || 1000
puts "Runs per agent: #{COUNT}"

if !options[:agent].nil?
  puts "Limiting to agent: #{options[:agent]}"
  agent_classes = agent_classes.select do |agent_class|
    agent_class.name == options[:agent]
  end
end

puts 'Running games'
rows = agent_classes.map do |agent_class|
  start_time = Time.now.to_f
  average_score = (0..(COUNT-1)).to_a.map do
    Game.new(agent_class: agent_class).deal!.play!.score
  end.sum / COUNT.to_f
  run_time = Time.now.to_f - start_time
  print '.'
  class_name = agent_class.name
  class_name += ' (Control)' if agent_class.control?
  [class_name, average_score, run_time]
end.sort_by do |d|
  d[1]
end.reverse.map do |d|
  [d[0], '%.4f' % d[1], '%.4f' % d[2]]
end
puts

puts(Terminal::Table.new(headings: ['Agent', 'Score', 'Time'], rows: rows).tap do |table|
  table.align_column(1, :right)
  table.align_column(2, :right)
end)

puts 'Finished'
