class Chef
  module SSH
    module PathHelpers

      def default_or_user_path(default, ssh_user)
        filename = File.basename(default)
        ssh_path = nil
        if (new_resource.user && !new_resource.path)
          home_path = `awk -F: -v v='#{new_resource.user}' '{if ($1==v) print $6}' /etc/passwd`.strip
          ssh_path = "#{home_path}/.ssh/#{filename.gsub('ssh_','')}"
        elsif new_resource.path
          ssh_path = new_resource.path
        else
          ssh_path = default
        end

        directory "Creating #{::File.dirname(ssh_path)} for #{ssh_user}" do
          owner ssh_user
          mode '0700'
          recursive true
          path ::File.dirname(ssh_path)
          user ssh_user
        end

        return ssh_path
      end
    end
  end
end
