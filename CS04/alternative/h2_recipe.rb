# Install required packages
package %w(wget unzip openjdk-17-jdk)

# Update and upgrade apt packages
execute 'update_upgrade' do
  command 'apt update && apt upgrade -y'
end

# Set JAVA_HOME system-wide
file '/etc/profile.d/jdk.sh' do
  content <<-EOH
  export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
  export PATH=$JAVA_HOME/bin:$PATH
  EOH
  mode '0644'
end

# Allow SSH on port 22
execute 'allow_ssh' do
  command 'ufw allow 22/tcp'
  not_if 'ufw status | grep "22/tcp"'
end

# Allow traffic on port 9095 from the application VM's IP
execute 'allow_app_vm' do
  command 'ufw allow from 192.168.138.144 to any port 9095'
  not_if 'ufw status | grep "192.168.138.144"'
end

# Enable the firewall
execute 'enable_ufw' do
  command 'ufw enable'
  action :run
end

# Download H2 database
remote_file '/tmp/h2.zip' do
  source 'https://github.com/h2database/h2database/releases/download/version-2.3.230/h2-2024-07-15.zip'
  action :create
end

# Unzip H2 database
archive_file 'extract_h2' do
  path '/tmp/h2.zip'
  destination '/home/vagrant'
  action :extract
end

# Create startup script for H2
file '/home/vagrant/start_h2.sh' do
  content <<-EOH
  #!/bin/bash
  java -cp /home/vagrant/h2/bin/h2*.jar org.h2.tools.Server -tcp -tcpAllowOthers -baseDir /home/vagrant/h2data
  EOH
  mode '0755'
end

# Configure H2 as a systemd service
file '/etc/systemd/system/h2.service' do
  content <<-EOH
  [Unit]
  Description=H2 Database Service
  After=network.target

  [Service]
  ExecStart=/home/vagrant/start_h2.sh
  User=vagrant
  Restart=always

  [Install]
  WantedBy=multi-user.target
  EOH
  mode '0644'
end

# Reload systemd and start H2 service
execute 'systemctl_daemon_reload' do
  command 'systemctl daemon-reload'
end

service 'h2' do
  action [:enable, :start]
end