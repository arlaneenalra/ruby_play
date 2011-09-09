

# class to hold a comment
class Comment < Sequel::Model
    plugin :validation_helpers
    def validate
        super

        validates_presence [:name, :comment], :message => 'Can not be left blank.'
        validates_format /^((\s*.+@.+\..+\s*)|\s*)$/, :email, :message => 'Does not look like a valid email address.'
        validates_format /^((\s*https?:\/\/.*$)|\s*)$/, :url, :message => 'Does not look like a valid web address.'
    end
end

