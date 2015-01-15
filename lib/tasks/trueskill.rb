namespace :trueskill do
  task setup_defaults: :environment do
    SetupDefaults.setup_defaults
    puts 'Success!!'
  end
end
