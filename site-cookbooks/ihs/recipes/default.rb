#
# Cookbook Name:: ihs
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# create temp dir
directory "#{node[:ihs][:image_dir]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# transfer image file 1 of 3
#cookbook_file "#{node[:ihs][:image_dir]}/#{node[:ihs][:image_file1]}" do
#  source "#{node[:ihs][:image_file1]}"
#  mode 00644
#  checksum ""
#end

# transfer image file 2 of 3
#cookbook_file "#{node[:ihs][:image_dir]}/#{node[:ihs][:image_file2]}" do
#  source "#{node[:ihs][:image_file2]}"
#  mode 00644
##  checksum ""
#end

# transfer image file 3 of 3
#cookbook_file "#{node[:ihs][:image_dir]}/#{node[:ihs][:image_file3]}" do
#  source "#{node[:ihs][:image_file3]}"
#  mode 00644
#  checksum ""
#end

# unzip image files
bash "unzip suppl image" do
  user "root"
  cwd "#{node[:ihs][:image_dir]}"
  code <<-EOC
    unzip "#{node[:ihs][:image_file1]}"
    unzip "#{node[:ihs][:image_file2]}"
    unzip "#{node[:ihs][:image_file3]}"
  EOC
  creates "#{node[:ihs][:image_dir]}/disk1"
  creates "#{node[:ihs][:image_dir]}/disk2"
  creates "#{node[:ihs][:image_dir]}/disk3"
end

# prepare response file
template "#{node[:ihs][:image_dir]}/WAS855_ihs_install.xml" do
  owner "root"
  group "root"
  mode 0644
end

# install ihs
execute "install ihs" do
  command <<-EOC
    "#{node[:im][:install_dir]}/eclipse/tools/imcl" -acceptLicense input "#{node[:ihs][:image_dir]}/WAS855_ihs_install.xml" -log /tmp/WAS855_ihs_install_log.xml
  EOC
  creates "#{node[:ihs][:install_dir]}/bin"
end

# port open
bash "open port" do
  code <<-EOC
    iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport #{node[:ihs][:port]} -j ACCEPT
    service iptables save
  EOC
end
