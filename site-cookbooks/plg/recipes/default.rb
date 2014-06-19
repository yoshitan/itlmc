#
# Cookbook Name:: plg
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# prepare response file
template "#{node[:plg][:image_dir]}/WAS855_plg_install.xml" do
  owner "root"
  group "root"
  mode 0644
end

# install plugin
execute "install plugin" do
  command <<-EOC
    "#{node[:im][:install_dir]}/eclipse/tools/imcl" -acceptLicense input "#{node[:plg][:image_dir]}/WAS855_plg_install.xml" -log /tmp/WAS855_plg_install_log.xml
  EOC
  creates "#{node[:plg][:install_dir]}"
end
