#
# Cookbook Name:: xxxbook
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "compat-libstdc++-33" do
  action :install
end

package "compat-db" do
  action :install
end

package "ksh" do
  action :install
end

package "gtk2" do
  action :install
end

package "gtk2-engines" do
  action :install
end

package "libXp" do
  action :install
end

package "libXmu" do
  action :install
end

package "libXtst" do
  action :install
end

package "pam" do
  action :install
end

package "elfutils" do
  action :install
end

package "elfutils-libs" do
  action :install
end

package "libXft" do
  action :install
end

package "libstdc++" do
  action :install
end

package "apr-util" do
  action :install
end

package "expat" do
  action :install
end

yum_package "glibc" do
  action :install
  arch "i686"
end

yum_package "libgcc" do
  action :install
  arch "i686"
end

group 'db2grp1' do
        group_name 'db2grp1'
        action [:create]
end

user 'db2inst1' do
        comment 'db2inst1'
        group 'db2grp1'
        password 'nine0xml'
        action [:create]
end

group 'db2fadm1' do
        group_name 'db2fadm1'
        action [:create]
end

user 'db2fenc1' do
        comment 'db2fenc1'
        group 'db2fadm1'
        password 'nine0xml'
        action [:create]
end
