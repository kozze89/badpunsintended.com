require 'erb'
require 'ostruct'

def read_jokes
  IO.readlines('jokes.txt')
end

def template(joke)
  ERB.new(File.read('post-template.erb'))
    .result(OpenStruct.new({joke: joke}).instance_eval { binding })
end

def remove_joke(jokes, joke)
  jokes.delete(joke)
  File.open('jokes.txt', 'w+') do |f|
    f.puts(jokes)
  end
end

def write_post(post)
  File.open('_posts/' + Time.now.strftime('%F') + '-pun-temp.markdown', 'w+') do |f|
    f.puts(post)
  end
end

def build_site
  system('jekyll build')
end

def push
  system('git add . -v')
  system('git commit -m "Added pun for ' + Time.now.strftime('%F') + '"')
  system('git push origin gh-pages')
end

def generate

  jokes = read_jokes
  joke = jokes.sample

  post = template(joke)
  #remove_joke(jokes, joke)

  write_post(post)
  build_site
end


generate
