require "spec_helper"


describe ExtraLoop::Storage::RemoteStore do

  describe "#get_transport" do
    context "with credentials" do
      subject { ExtraLoop::Storage::RemoteStore::get_transport(:fusion_tables, ['username', 'password'] ) }

      it { should be_a_kind_of ExtraLoop::Storage::FusionTables }
    end

    context "without credentials or config file" do 
      it "should raise a MissingCredentials error" do
        expect { ExtraLoop::Storage::RemoteStore::get_transport(:fusion_tables, nil, {:schema => {:session_id => 'string', :index => 'number'}}) }.to raise_exception(ExtraLoop::Storage::Exceptions::MissingCredentialsError)
      end
    end

    context "with credentials in config file" do
      before do
        config={
          :datastore => {
            :fusion_tables => {
              :username => 'test_user',
              :password => 'password'
            }
          }
        }

        config_file = File.join(Etc.getpwuid.dir, '.extraloop.yml')
        FileUtils.mv(config_file, config_file + ".diabled") if File.exist? config_file
        File.open(config_file, 'w') { |f| f.write config.to_yaml }
      end

      it "should not raise a MissingCredentials error" do
        expect { ExtraLoop::Storage::get_transport(:fusion_tables, nil, {:schema => {:session_id => 'string', :index => 'number'}}) }.to_not raise_exception(ExtraLoop::Storage::Exceptions::MissingCredentialsError)
      end

      after do
        config_file = File.join(Etc.getpwuid.dir, '.extraloop.yml')
        FileUtils.rm config_file
        FileUtils.mv(config_file + ".disabled", config_file) if File.exist? config_file + ".disabled"
      end

     end
  end
end
