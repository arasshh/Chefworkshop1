# Cookbook:: tomcat
# Recipe:: default
# Copyright:: 2018, The Authors, All Rights Reserved.
#sudo yum install java-1.7.0-openjdk-devel
package 'java-1.7.0-openjdk-devel'

#sudo groupadd tomcat
group 'tomcat'

#sudo useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat
user 'tomcat' do
  manage_home false
  shell '/bin/nologin'
  group 'tomcat'
  home '/opt/tomcat'
end

#wget http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz
remote_file 'apache-tomcat-8.5.31.tar.gz' do
  source 'http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz'
end

#sudo mkdir /opt/tomcat & #sudo chgrp -R tomcat /opt/tomcat
directory '/opt/tomcat' do
  action [:create]
  group 'tomcat'
  recursive true
end

#unzipp the file
execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'

execute ' chmod -R g+r opt/tomcat/conf'
#directory 'opt/tomcat/conf' do
 # mode '0040'
 # recursive true
#end

execute ' chmod g+x opt/tomcat/conf'
#directory 'opt/tomcat/conf' do
 # mode '0010'
#end


#sudo chown -R tomcat webapps/ work/ temp/ logs/
%w[/opt/tomcat/webapps /opt/tomcat/work  /opt/tomcat/temp /opt/tomcat/logs].each do |path|
 directory path do 
    owner 'tomcat'
    group 'tomcat'
  end
end

# sudo vi /etc/systemd/system/tomcat.service

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

execute ' systemctl daemon-reload'
#execute 'systemctl daemon-reload' do
 #   command 'systemctl daemon-reload'
  #  action :nothing
 # end

#service 'tomcat' do
  # action [:start, :enable]
#end

execute' systemctl start tomcat'

execute 'systemctl enable tomcat'
