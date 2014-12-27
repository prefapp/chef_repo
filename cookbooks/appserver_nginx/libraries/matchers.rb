if defined?(ChefSpec)

    def create_nginx_fpm_site(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:nginx_fpm_site, :create, resource_name)
    end
end
