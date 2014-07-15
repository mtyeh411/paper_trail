require 'spec_helper'

describe PaperTrail::Version do
  it "should include the `VersionConcern` module to get base functionality" do
    PaperTrail::Version.should include(PaperTrail::VersionConcern)
  end

  describe "Attributes" do
    it { should have_db_column(:item_type).of_type(:string) }
    it { should have_db_column(:item_id).of_type(:integer) }
    it { should have_db_column(:event).of_type(:string) }
    it { should have_db_column(:whodunnit).of_type(:string) }
    it { should have_db_column(:object).of_type(:text) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column :transaction_id }
  end

  describe "Associations" do
    it { should belong_to :item }
    it { should have_many :version_associations }
  end

  describe "Indexes" do
    it { should have_db_index([:item_type, :item_id]) }
    it { should have_db_index :transaction_id }
  end

  describe "Scopes" do
    it '#within_transaction(id)' do 
      expect(subject.class.within_transaction(1).to_sql).to eq subject.class.where(transaction_id:1).to_sql 
    end
  end

  describe "Methods" do
    describe "Instance" do
      subject { PaperTrail::Version.new(attributes) rescue PaperTrail::Version.new }

      describe :terminator do
        it { should respond_to(:terminator) }

        let(:attributes) { {:whodunnit => Faker::Name.first_name} }

        it "is an alias for the `whodunnit` attribute" do
          subject.whodunnit.should == attributes[:whodunnit]
        end
      end

      describe :version_author do
        it { should respond_to(:version_author) }

        it "should be an alias for the `terminator` method" do
          subject.method(:version_author).should == subject.method(:terminator)
        end
      end
    end
  end
end
