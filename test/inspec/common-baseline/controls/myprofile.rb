# encoding: utf-8
# copyright: 2019, Hiroki KUNITAKE

title 'MyProfile section'

control 'myprofile-01' do
  impact 0.7
  title 'Create myprofile.txt'
  desc 'Check contents'
  describe file('/var/tmp/myprofile.txt') do
    it { should be_file }
    its('content') { should match /^My name is #{attribute('my_name')}/ }
    its('content') { should match /^I'm in #{attribute('my_group')}/ }
  end
end
