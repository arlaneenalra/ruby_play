

# initial database setup
Sequel.migration do
    change do
        create_table(:comments) do
            primary_key :comment_id
            String :name, :null => false
            String :email, :null => false
            String :url, :null => false
            String :comment, :text => true
        end
    end
end
