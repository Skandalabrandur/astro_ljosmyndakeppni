p = Post.all
h = Hash.new{0}
p.each do |post|
	h[post.email] += 1
end

puts "#{h}"
