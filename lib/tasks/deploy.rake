namespace :deploy do
  desc 'Deploy to Heroku production environment'
  task :production do
    puts 'Deploying Production'

    Paratrooper::Deploy.new('haz-commitz', {
      branch: 'master'
    }).deploy
  end
end
