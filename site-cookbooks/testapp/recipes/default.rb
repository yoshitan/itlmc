#
# Cookbook Name:: testapp
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# prepare response file
template "/tmp/deploy_app.py" do
  owner "root"
  group "root"
  mode 0644
end

# deploy app
execute "deploy app" do
  command <<-EOC
    "#{node[:was][:install_dir]}/profiles/#{node[:was_cluster][:dmgr_name]}/bin/wsadmin.sh" -lang jython -f /tmp/deploy_app.py
  EOC
end

# prepare response file
template "/tmp/start_app.py" do
  owner "root"
  group "root"
  mode 0644
end

# start app
execute "start app" do
  command <<-EOC
    "#{node[:was][:install_dir]}/profiles/#{node[:was_cluster][:dmgr_name]}/bin/wsadmin.sh" -lang jython -f /tmp/start_app.py
  EOC
end

# restart ihs
execute "restart ihs" do
  command <<-EOC
    "#{node[:ihs][:install_dir]}/bin/apachectl" restart
  EOC
end
