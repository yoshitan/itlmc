#
# Cookbook Name:: was-cluster
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# create dmgr profile
execute "create dmgr profile" do
  command <<-EOC
  "#{node[:was][:install_dir]}/bin/manageprofiles.sh" -create -templatePath "#{node[:was][:install_dir]}/profileTemplates/dmgr" -profileName "#{node[:was_cluster][:dmgr_name]}"
  EOC
  creates "#{node[:was][:install_dir]}/profiles/#{node[:was_cluster][:dmgr_name]}"
end

# create managed profile
node[:was_cluster][:managed_name].each_with_index do |managed,i|
  execute "create managed profile" do
    command <<-EOC
       "#{node[:was][:install_dir]}/bin/manageprofiles.sh" -create -templatePath "#{node[:was][:install_dir]}/profileTemplates/managed" -profileName "#{managed}" -nodeName "#{node[:was_cluster][:node_name][i]}"
    EOC
    creates "#{node[:was][:install_dir]}/profiles/#{managed}"
  end
end

# start dmgr
execute "start dmgr" do
  command <<-EOC
    "#{node[:was][:install_dir]}/profiles/#{node[:was_cluster][:dmgr_name]}/bin/startManager.sh"
  EOC
  creates "#{node[:was][:install_dir]}/profiles/#{node[:was_cluster][:dmgr_name]}/logs/dmgr/dmgr.pid"
end

# add node to dmgr (dmgr should be running on the same server)
node[:was_cluster][:managed_name].each do |managed|
  execute "add managed node to dmgr" do
    command <<-EOC
      "#{node[:was][:install_dir]}/profiles/#{managed}/bin/addNode.sh" "#{node[:hostname]}"
    EOC
    creates "#{node[:was][:install_dir]}/profiles/#{managed}/servers/nodeagent"
  end
end

# prepare response file
template "/tmp/create_cluster.py" do
  owner "root"
  group "root"
  mode 0644
end

# create cluster
execute "create cluster" do
  command <<-EOC
    "#{node[:was][:install_dir]}/profiles/#{node[:was_cluster][:dmgr_name]}/bin/wsadmin.sh" -lang jython -f /tmp/create_cluster.py
  EOC
  creates "#{node[:was][:install_dir]}/profiles/#{node[:was_cluster][:dmgr_name]}/config/cells/#{node[:hostname]}Cell01/clusters/#{node[:was_cluster][:cluster_name]}"
end

# start nodeagent if it is not running.
node[:was_cluster][:managed_name].each do |managed|
  execute "start nodeagent if it is not running" do
    command <<-EOC
      "#{node[:was][:install_dir]}/profiles/#{managed}/bin/startNode.sh"
    EOC
    creates "#{node[:was][:install_dir]}/profiles/#{managed}/logs/nodeagent/nodeagent.pid"
  end
end

# prepare response file
template "/tmp/start_cluster.py" do
  owner "root"
  group "root"
  mode 0644
end

# start cluster
execute "start cluster" do
  command <<-EOC
    "#{node[:was][:install_dir]}/profiles/#{node[:was_cluster][:dmgr_name]}/bin/wsadmin.sh" -lang jython -f /tmp/start_cluster.py
  EOC
end

# prepare response file
template "/tmp/create_webserver.py" do
  owner "root"
  group "root"
  mode 0644
end

# create webserver definition
execute "create webserver" do
  command <<-EOC
    "#{node[:was][:install_dir]}/profiles/#{node[:was_cluster][:dmgr_name]}/bin/wsadmin.sh" -lang jython -f /tmp/create_webserver.py
  EOC
  creates "#{node[:was][:install_dir]}/profiles/#{node[:was_cluster][:dmgr_name]}/config/cells/#{node[:hostname]}Cell01/nodes/#{node[:was_cluster][:node_name][0]}/servers/#{node[:was_cluster][:webserver_name]}"
end

# prepare response file
template "/tmp/plg_responsefile.txt" do
  owner "root"
  group "root"
  mode 0644
end

# configure plugin
execute "config plugin" do
  command <<-EOC
    "#{node[:wct][:install_dir]}/WCT/wctcmd.sh" -tool pct -defLocPathname "#{node[:plg][:install_dir]}" -defLocName defName -createDefinition -response /tmp/plg_responsefile.txt >> /tmp/plg.log
  EOC
#  creates "#{node[:plg][:install_dir]}/config/#{node[:wct][:webserver_name]}"
end

# start IHS
execute "start ihs" do
  command <<-EOC
    "#{node[:ihs][:install_dir]}/bin/apachectl" start
  EOC
  creates "#{node[:ihs][:install_dir]}/logs/httpd.pid"
end
