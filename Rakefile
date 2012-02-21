require "date"

def releases
  releases = `git tag -l v[0-9]*`.split(/\n/).map { |v| v.gsub(/^v/, '').split(".").map(&:to_i) }
  releases.empty? && [[0,0,1]] || releases
end

def new_release
  last_version, new_version = releases.last, releases.last
  new_version[-1]+=1
  new_version
end

def gemspec_file
  Dir["*.gemspec"].first
end

gem_name = File.open(gemspec_file, "r") do |file|
  file.readlines.each do |line|
    break $2 if line.match /\.name\s*=\s*("|')([^"']*)("|')/
  end
end

task :update_gemspec do
  File.open(gemspec_file, "r+") do |file|
    version_regex = Regexp.new "(\.version\s*=\s*)(['\"])(#{releases.last.join('.')})(['\"])"
    date_regex = /(.date\s*=\s*)(['\"])(\d{4}-\d{2}-\d{2})(['\"])/
    lines = file.readlines

    lines.each do |line|
      line.gsub!(version_regex, "#{$1}'#{new_release.join('.')}'") if line.match(version_regex)
      line.gsub!(date_regex, "#{$1}'#{Date.today}'") if line.match(date_regex)
    end

    file.pos = 0
    file.print(lines.join)
    file.truncate(file.pos)
  end
end

task :commit do
  `git add #{gemspec_file} && git commit -m "Updated gemspec for new release: #{new_release.join('.')}"`
end

task :tag_release do
  `git tag v#{new_release.join('.')}`
end

task :github_push do
  `git push origin master`
  `git push origin master --tags`
end

task :build_gem do
  `gem build #{gemspec_file}`
end

task :push_gem do
  `gem push #{gem_name}-#{new_release.join('.')}.gem`
end

task :make_release => [:update_gemspec, :commit, :tag_release, :github_push, :build_gem, :push_gem] do
  puts "done :)"
end