# frozen_string_literal: true

require "rails_helper"

RSpec.describe "UUID primary keys" do # rubocop:disable RSpec/DescribeClass
  let(:connection) { ActiveRecord::Base.connection }
  let(:tables) { connection.tables - %w[schema_migrations ar_internal_metadata] }

  it "gives every table a uuidv7() primary key", :aggregate_failures do
    tables.each do |table|
      id = connection.columns(table).find { |column| column.name == connection.primary_key(table) }
      expect(id&.sql_type).to eq("uuid"), "#{table} primary key is #{id&.sql_type.inspect}"
      expect(id&.default_function).to eq("uuidv7()"), "#{table} primary key defaults to #{id&.default_function}"
    end
  end

  def non_uuid_references
    tables.flat_map do |table|
      connection.columns(table)
                .select { |column| column.name.end_with?("_id") && column.sql_type != "uuid" }
                .map { |column| "#{table}.#{column.name}" }
    end
  end

  it "types every id-suffixed column as uuid" do
    expect(non_uuid_references).to be_empty
  end

  it "defaults new tables to uuidv7() keys, in creation order", :aggregate_failures do
    connection.create_table(:uuid_probes, id: :uuid, temporary: true)
    ids = Array.new(3) { connection.select_value("INSERT INTO uuid_probes DEFAULT VALUES RETURNING id") }
    expect(ids).to all(match(/\A\h{8}-\h{4}-7\h{3}-/))
    expect(ids).to eq(ids.sort)
  end
end
