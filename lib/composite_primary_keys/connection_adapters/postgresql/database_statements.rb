module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module DatabaseStatements
        def sql_for_insert(sql, pk, binds, returning) # :nodoc:
          if supports_insert_returning?
            if pk.nil?
              # Extract the table from the insert sql. Yuck.
              table_ref = extract_table_ref_from_insert_sql(sql)
              pk = primary_key(table_ref) if table_ref
            end

            returning_columns = returning || Array(pk)

            returning_columns_statement = returning_columns.map { |c| quote_column_name(c) }.join(", ")
            sql = "#{sql} RETURNING #{returning_columns_statement}" if returning_columns.any?
          end

          [sql, binds]
        end
      end
    end
  end
end
