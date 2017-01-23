require "pathname"

# Various tasks for CI
desc "Fetch factorio data"
task "factorio:fetch" do
  sh "wget", "https://www.dropbox.com/s/0hc54g4c9ntn5ro/factorio-data-0.14.21.7z"
end

desc "Unpack factorio data"
task "factorio:unpack" do
  if Pathname("factorio").exist?
    sh "trash", "factorio"
  end
  Pathname("factorio/data").mkpath
  Dir.chdir("factorio/data") do
    sh "7z x ../../factorio-data-0.14.21.7z"
  end
end

desc "Build Happy Factorio (based on sample data)"
task "build" do
  sh "./bin/build_happy_factorio_mod", "factorio"
end
