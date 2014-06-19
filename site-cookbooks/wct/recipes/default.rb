#
# Cookbook Name:: wct
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# prepare response file
template "#{node[:wct][:image_dir]}/WAS855_wct_install.xml" do
  owner "root"
  group "root"
  mode 0644
end

# install Customization Toolbox
execute "install customization toolbox" do
  command <<-EOC
    "#{node[:im][:install_dir]}/eclipse/tools/imcl" -acceptLicense input "#{node[:wct][:image_dir]}/WAS855_wct_install.xml" -log /tmp/WAS855_wct_install_log.xml
  EOC
  creates "#{node[:wct][:install_dir]}"
end
