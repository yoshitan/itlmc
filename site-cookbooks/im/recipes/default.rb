#
# Cookbook Name:: im
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# create temp dir
directory "#{node[:im][:image_dir]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# transfer image file
#cookbook_file "#{node[:im][:image_dir]}/#{node[:im][:image_file]}" do
#  source "#{node[:im][:image_file]}"
#  mode 00644
#  checksum "0e341395aa28148551b93830ef760d43c3afcfa85ab119f872a18bfcf0119e92"
#end

# unzip image file
bash "unzip im" do
  user "root"
  cwd "#{node[:im][:image_dir]}"
  code <<-EOC
    unzip "#{node[:im][:image_file]}"
  EOC
  creates "#{node[:im][:image_dir]}/installc"
end

# install Installation Manager
bash "install im" do
  code <<-EOC
    "#{node[:im][:image_dir]}/installc" -acceptLicense
  EOC
  creates "#{node[:im][:install_dir]}/eclipse/IBMIM"
end
