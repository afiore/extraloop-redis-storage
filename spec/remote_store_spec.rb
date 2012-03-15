require "../lib/extraloop/redis-storage.rb"
require "./helpers/spec_helper"


describe ExtraLoop::Storage::RemoteStore do
  describe "#get_store" do
    subject { ExtraLoop::Storage::RemoteStore::get_transport(:fusion_tables, ['username', 'password'] ) }


    it { should be_a_kind_of ExtraLoop::Storage::FusionTables }
  end
end
