java_home = "/usr/lib/jvm/java-17-openjdk-arm64"
gradle_version = "8.4"
gradle_url = "https://services.gradle.org/distributions/gradle-#{gradle_version}-bin.zip"
gradle_dest = "/opt/gradle"
repo_url = "https://github.com/tonebarbosa/cogsi-1190404-1191106-1190699.git"

# Update and upgrade apt packages
execute 'update_upgrade' do
  command 'apt update && apt upgrade -y'
end

# Install required packages
package %w(git openjdk-17-jdk maven wget unzip)

# Set JAVA_HOME system-wide
file '/etc/profile.d/jdk.sh' do
  content <<-EOH
  export JAVA_HOME=#{java_home}
  export PATH=$JAVA_HOME/bin:$PATH
  EOH
  mode '0644'
end

# Download and unzip Gradle
remote_file '/tmp/gradle.zip' do
  source gradle_url
  action :create
end

# Ensure /opt/gradle directory exists
directory gradle_dest do
  mode '0755'
  action :create
end

# Unzip Gradle
archive_file 'extract_gradle' do
  path '/tmp/gradle.zip'
  destination gradle_dest
  action :extract
end

# Create symlink for Gradle
link '/usr/bin/gradle' do
  to "#{gradle_dest}/gradle-#{gradle_version}/bin/gradle"
end

# Clone the repository
git 'cogsi_repository' do
  repository repo_url
  destination '/home/vagrant/cogsi-1190404-1191106-1190699'
  revision 'feature/cogsi-22'
  action :sync
end

# Configure application.properties for Spring Boot
file '/home/vagrant/cogsi-1190404-1191106-1190699/CS02/tut-rest-gradle/app/src/main/application.properties' do
  content <<-EOH
  spring.datasource.url=jdbc:h2:tcp://localhost:1011/./test
  spring.datasource.driverClassName=org.h2.Driver
  spring.datasource.username=sa
  spring.datasource.password=
  EOH
  mode '0644'
end

# Wait for H2 database to be ready on port 9095
ruby_block 'wait_for_database' do
  block do
    require 'socket'
    until TCPSocket.new('192.168.138.143', 9095) rescue false
      sleep 3
    end
  end
end

# Build and start the REST service
execute 'build_and_start_rest_service' do
  command <<-EOH
    source /etc/profile.d/jdk.sh
    cd /home/vagrant/cogsi-1190404-1191106-1190699/CS02/tut-rest-gradle/app
    gradle build
    gradle bootRun &
  EOH
  environment 'START_REST_SERVICE' => 'true'
  only_if { ENV['START_REST_SERVICE'] == 'true' }
end