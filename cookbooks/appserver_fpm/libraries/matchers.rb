if defined?(ChefSpec)

    def create_fpm_pool(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:php5_fpm_pool, :create, resource_name)
    end
end
