
# Add moderated flag
Sequel.migration do
    change do
        add_column :comments, :deleted, TrueClass, :default => false
        add_column :comments, :moderated, TrueClass, :default => false
        add_column :comments, :ip_address, String, :size => 50, :null => false, :default => ''
    end
end
