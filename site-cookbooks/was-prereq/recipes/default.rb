#
# Cookbook Name:: was-prereq
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

service "iptables" do
  action :stop
end

