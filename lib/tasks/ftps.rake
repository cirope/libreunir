namespace :ftps do
  desc 'Download zip file from the config'
  task get_zip: :environment do
    @ftps = Ftps.new
    @ftps.make_folder
    @ftps.set_mode
    @ftps.set_context
    @ftps.connect_and_login
    @ftps.get_file
  end
end
