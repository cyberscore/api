require 'fileutils'

module Cyberscore
  class API < Sinatra::Base


    get '/submissions' do
      user = Model::User.find(:username => 'locks')

      subs = user.records.first(10)

      collection             = OpenStruct.new.extend(Representer::Submission::Collection)
      collection.total       = subs.size
      collection.submissions = subs

      collection.to_json
    end

    get '/submissions/:submission' do
      # submission_id = params['submission'].to_i
      # submission    = Model::Record[submission_id]
      #
      # collection = submission.extend(Representer::Submission::Item)
content_type :html

form = <<-EOS
<form action="/submissions/123456" method="post" enctype="multipart/form-data">
  <p>
    <input type="text" name="username" placeholder="username">
  </p>
  <p>
    <label for="file">File:</label>
    <input name="file" type="file">
  </p>

  <p><input name="commit" type="submit" value="Submit"></p>
</form>
EOS
    end

    post '/submissions/:submission' do
      protected!

      submission = params['submission']

      form     = params['file']
      filename = form[:filename]
      type     = form[:type]
      tempfile = form[:tempfile]

      final_name = "#{submission}-#{filename}"

      File.open("public/#{final_name}", 'wb') {|file| file.write(tempfile.read) }

content_type :html
      "<img src=\"/#{final_name}\">"
    end

  end
end
