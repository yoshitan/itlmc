#
# Cookbook Name:: was
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# create temp dir
directory "#{node[:was][:image_dir]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# transfer image file 1 of 3
#cookbook_file "#{node[:was][:image_dir]}/#{node[:was][:image_file1]}" do
#  source "#{node[:was][:image_file1]}"
#  mode 00644
#  checksum "b1333962ba4b25c8632c7e4c82b472350337e99febac8f70ffbd551ca3905e83"
#end

# transfer image file 2 of 3
#cookbook_file "#{node[:was][:image_dir]}/#{node[:was][:image_file2]}" do
#  source "#{node[:was][:image_file2]}"
#  mode 00644
#  checksum "440b7ed82089d43b1d45c1e908bf0a1951fed98f2542b6d37c8b5e7274c6b1c9"
#end

# transfer image file 3 of 3
#cookbook_file "#{node[:was][:image_dir]}/#{node[:was][:image_file3]}" do
#  source "#{node[:was][:image_file3]}"
#  mode 00644
#  checksum "b73ae070656bed6399a113c2db9fb0abaf5505b0d41c564bf2a58ce0b1e0dcd2"
#end

# unzip image files
bash "unzip was" do
  user "root"
  cwd "#{node[:was][:image_dir]}"
  code <<-EOC
    unzip "#{node[:was][:image_file1]}"
    unzip "#{node[:was][:image_file2]}"
    unzip "#{node[:was][:image_file3]}"
  EOC
  creates "#{node[:was][:image_dir]}/disk1"
  creates "#{node[:was][:image_dir]}/disk2"
  creates "#{node[:was][:image_dir]}/disk3"
end

# prepare response file
template "#{node[:was][:image_dir]}/WAS855_install.xml" do
  owner "root"
  group "root"
  mode 0644
end


# install was
execute "install was" do
  command <<-EOC
    "#{node[:im][:install_dir]}/eclipse/tools/imcl" -acceptLicense input "#{node[:was][:image_dir]}/WAS855_install.xml" -log /tmp/WAS855_install_log.xml
  EOC
  creates "#{node[:was][:install_dir]}/bin"
end
