require("active_mocker/mock")
class CandidateMock < ActiveMocker::Base
  created_with("2.3.0")
  # _modules_constants.erb
  prepend(Endorsements)
  #_class_methods.erb
  class << self
    def attributes
      @attributes ||= HashWithIndifferentAccess.new(id: nil, contest_id: nil, photo: nil, name: nil, bio: nil, facebook: nil, website: nil, twitter: nil, created_at: nil, updated_at: nil, party: nil, position: nil).merge(super)
    end

    def types
      @types ||= ActiveMocker::HashProcess.new({ id: Integer, contest_id: Integer, photo: String, name: String, bio: String, facebook: String, website: String, twitter: String, created_at: DateTime, updated_at: DateTime, party: String, position: Integer }, method(:build_type)).merge(super)
    end

    def associations
      @associations ||= { contest: nil, guide: nil, audits: nil, translations: nil, answers: nil, endorsements: nil }.merge(super)
    end

    def associations_by_class
      @associations_by_class ||= { "Contest" => { belongs_to: [:contest] }, "Guide" => { has_one: [:guide] }, "Audited::Adapters::ActiveRecord::Audit" => { has_many: [:audits] }, "Candidate::Translation" => { has_many: [:translations] }, "Answer" => { has_many: [:answers] }, "Endorsement" => { has_many: [:endorsements] } }.merge(super)
    end

    def mocked_class
      "Candidate"
    end

    private(:mocked_class)
    def attribute_names
      @attribute_names ||= attributes.stringify_keys.keys
    end

    def primary_key
      "id"
    end

    def abstract_class?
      false
    end

    def table_name
      "candidates" || super
    end

  end

  # _attributes.erb
  def id
    read_attribute(:id)
  end

  def id=(val)
    write_attribute(:id, val)
  end

  def contest_id
    read_attribute(:contest_id)
  end

  def contest_id=(val)
    write_attribute(:contest_id, val)
  end

  def photo
    read_attribute(:photo)
  end

  def photo=(val)
    write_attribute(:photo, val)
  end

  def name
    read_attribute(:name)
  end

  def name=(val)
    write_attribute(:name, val)
  end

  def bio
    read_attribute(:bio)
  end

  def bio=(val)
    write_attribute(:bio, val)
  end

  def facebook
    read_attribute(:facebook)
  end

  def facebook=(val)
    write_attribute(:facebook, val)
  end

  def website
    read_attribute(:website)
  end

  def website=(val)
    write_attribute(:website, val)
  end

  def twitter
    read_attribute(:twitter)
  end

  def twitter=(val)
    write_attribute(:twitter, val)
  end

  def created_at
    read_attribute(:created_at)
  end

  def created_at=(val)
    write_attribute(:created_at, val)
  end

  def updated_at
    read_attribute(:updated_at)
  end

  def updated_at=(val)
    write_attribute(:updated_at, val)
  end

  def party
    read_attribute(:party)
  end

  def party=(val)
    write_attribute(:party, val)
  end

  def position
    read_attribute(:position)
  end

  def position=(val)
    write_attribute(:position, val)
  end

  # _associations.erb
  # belongs_to
  def contest
    read_association(:contest) || write_association(:contest, classes("Contest").try do |k|
      k.find_by(id: contest_id)
    end)
  end

  def contest=(val)
    write_association(:contest, val)
    ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :contest_id).item
  end

  def build_contest(attributes = {}, &block)
    association = classes("Contest").try(:new, attributes, &block)
    unless association.nil?
      write_association(:contest, association)
    end

  end

  def create_contest(attributes = {}, &block)
    association = classes("Contest").try(:create, attributes, &block)
    unless association.nil?
      write_association(:contest, association)
    end

  end

  alias_method(:create_contest!, :create_contest)
  # has_one
  def guide
    read_association(:guide)
  end

  def guide=(val)
    write_association(:guide, val)
    ActiveMocker::HasOne.new(val, child_self: self, foreign_key: "guide_id").item
  end

  def build_guide(attributes = {}, &block)
    if classes("Guide")
      write_association(:guide, classes("Guide").new(attributes, &block))
    end

  end

  def create_guide(attributes = {}, &block)
    if classes("Guide")
      write_association(:guide, classes("Guide").new(attributes, &block))
    end

  end

  alias_method(:create_guide!, :create_guide)
  # has_many
  def audits
    read_association(:audits, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "auditable_id", foreign_id: self.id, relation_class: classes("Audited::Adapters::ActiveRecord::Audit"), source: "")
    end)
  end

  def audits=(val)
    write_association(:audits, ActiveMocker::HasMany.new(val, foreign_key: "auditable_id", foreign_id: self.id, relation_class: classes("Audited::Adapters::ActiveRecord::Audit"), source: ""))
  end

  def translations
    read_association(:translations, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "candidate_id", foreign_id: self.id, relation_class: classes("Candidate::Translation"), source: "")
    end)
  end

  def translations=(val)
    write_association(:translations, ActiveMocker::HasMany.new(val, foreign_key: "candidate_id", foreign_id: self.id, relation_class: classes("Candidate::Translation"), source: ""))
  end

  def answers
    read_association(:answers, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "candidate_id", foreign_id: self.id, relation_class: classes("Answer"), source: "")
    end)
  end

  def answers=(val)
    write_association(:answers, ActiveMocker::HasMany.new(val, foreign_key: "candidate_id", foreign_id: self.id, relation_class: classes("Answer"), source: ""))
  end

  def endorsements
    read_association(:endorsements, lambda do
      ActiveMocker::HasMany.new([], foreign_key: "endorsed_id", foreign_id: self.id, relation_class: classes("Endorsement"), source: "")
    end)
  end

  def endorsements=(val)
    write_association(:endorsements, ActiveMocker::HasMany.new(val, foreign_key: "endorsed_id", foreign_id: self.id, relation_class: classes("Endorsement"), source: ""))
  end

  # _scopes.erb
  module Scopes
    include(ActiveMocker::Base::Scopes)
  end

  extend(Scopes)
  class ScopeRelation < ActiveMocker::Association
    include(CandidateMock::Scopes)
  end

  def self.__new_relation__(collection)
    CandidateMock::ScopeRelation.new(collection)
  end

  private_class_method(:__new_relation__)
  # _recreate_class_method_calls.erb
  def self.attribute_aliases
    @attribute_aliases ||= {}.merge(super)
  end

  def assign_attributes(attributes)
    call_mock_method(method: __method__, caller: Kernel.caller, arguments: [attributes])
  end

end