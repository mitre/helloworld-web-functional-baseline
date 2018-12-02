# encoding: utf-8
# copyright: 2018, The Authors

control 'docker-checks-1.1' do
  impact 0.7 # High Impact
  tag "nist": ['CM-6', 'Rev_4']
  title 'Verify Docker Container exists and is running'

  describe docker_container(name: attribute('application_container_name')) do
    it { should exist }
    it { should be_running }
  end
end

control 'docker-checks-1.2' do
  impact 0.5 # Medium Impact
  title 'Verify Docker Container Run commands'
  tag "nist": ['CM-6', 'Rev_4']

  describe docker_container(name: attribute('application_container_name')) do
    its('command') { should eq '/app/helloworld-web' }
  end
end

control 'docker-checks-1.4' do
  impact 0.5 # Medium Impact
  title 'Verify Container published ports'
  tag "nist": ['CM-6', 'Rev_4']

  describe docker_container(name: attribute('application_container_name')) do
    its('ports') { should eq '0.0.0.0:3000->3000/tcp' }
  end
end

application_url = attribute('application_url')

control 'application-checks-2.1' do
  impact 0.7 # High Impact
  title 'Verify application is running'
  tag "nist": ['CM-6', 'Rev_4']

  describe.one do
    describe http("http://#{application_url}", enable_remote_worker: true) do
      its('status') { should cmp 200 }
    end

    describe http("https://#{application_url}", enable_remote_worker: true) do
      its('status') { should cmp 200 }
    end
  end
end

control 'application-checks-2.2' do
  impact 0.5 # Medium Impact
  title 'Validate application response'
  tag "nist": ['CM-6', 'Rev_4']

  describe http("http://#{application_url}", enable_remote_worker: true) do
    its('body.chomp') { should cmp "Hello world!" }
  end
end
