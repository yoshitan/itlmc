#
# Cookbook Name:: db2
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "install DB2" do
  command "/tmp/db2/expc/db2_install -b /opt/ibm/db2/V10.5 -f NOTSAMP"
end

=begin
execute "add group" do
  command "groupadd -g 201 db2grp2"
end

execute "add user" do
  command "useradd -b /home/db2inst2 -d /home/db2inst1 -g db2grp2 -m db2inst1"
end
=end

execute "create DB2 instance" do
  command "/opt/ibm/db2/V10.5/instance/db2icrt -s wse -u db2inst1 -u db2fenc1 db2inst1"
end

execute "db2level" do
  user "db2inst1"
  command "/home/db2inst1/sqllib/bin/db2level"
end
