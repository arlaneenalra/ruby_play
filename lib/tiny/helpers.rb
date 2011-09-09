
# render error messages from sql validation
def render_errors(obj, sym)
    @error = obj.errors.on(sym)
    @error ||= []

    haml :error_partial
end

