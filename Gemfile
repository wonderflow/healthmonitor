#source :rubygems
source "https://ruby.taobao.org" 
gem "eventmachine", "~> 0.12.10"
gem "logging", "~> 1.5.0"
gem "em-http-request", "~> 0.3.0"
gem "nats", "= 0.4.22"
gem "yajl-ruby", "~> 0.8.2"
gem "uuidtools"
gem "thin"
gem "sinatra"
gem "rake"

group :development do
  gem "ruby-debug", :platforms => :ruby_18
  gem "ruby-debug19", :platforms => :ruby_19
end

group :development, :test do
  gem "ci_reporter"
  gem "rspec", "~>2.10"

  gem "rcov", :platforms => :ruby_18
  gem "simplecov", :platforms => :ruby_19
  gem "simplecov-rcov", :platforms => :ruby_19
end
