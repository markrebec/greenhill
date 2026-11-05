# frozen_string_literal: true

# Every table's primary key is a UUID (see the generator default in
# config/application.rb). Rails hardcodes gen_random_uuid() (random v4) as
# the default for `create_table id: :uuid`; this swaps in Postgres 18's
# native uuidv7(), which is time-ordered: index inserts stay append-mostly,
# and ordering by id still means creation order. Patched at the table
# definition, not the migration template, so migrations from gems' own
# generators (Devise, ActiveAdmin) get it too. schema.rb records the default
# explicitly, so loading the schema doesn't depend on this.
module UuidV7PrimaryKeys
  def primary_key(name, type = :primary_key, **options)
    options[:default] = options.fetch(:default, -> { "uuidv7()" }) if type == :uuid
    super
  end
end

ActiveSupport.on_load(:active_record_postgresqladapter) do
  ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition.prepend(UuidV7PrimaryKeys)
end
