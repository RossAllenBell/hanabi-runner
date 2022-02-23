require 'terminal-table'

puts 'Loading files'
Dir['./lib/**/*.rb'].each {|file| require file }
Dir['./agents/**/*.rb'].each {|file| require file }

puts 'Detecting agent classes'
agent_classes = ObjectSpace.each_object(Class).select { |klass| klass < Agent }.sort_by(&:name)

puts "Agent classes: #{agent_classes.map(&:name).join(', ')}"

puts 'Running games'
rows = agent_classes.map do |agent_class|
  start_time = Time.now.to_f
  average_score = (0..999).to_a.map do
    Game.new(agent_class: agent_class).deal!.play!.score
  end.sum / 1000.0
  run_time = Time.now.to_f - start_time
  print '.'
  [agent_class.name, average_score, run_time]
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
