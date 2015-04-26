desc "Setup Redmine."

task :redmine_setup => :environment do
  #host_name = ENV['redmine_host_name']
  #unless host_name
  #  fail "redmine_host_name not specified."
  #end

  count = 0

  {
    #host_name:               host_name,
    text_formatting:         'markdown',
    repositories_encodings:  'utf8,cp932,euc-jp',
    date_format:             '%Y-%m-%d',
    time_format:             '%H:%M',
    user_format:             :lastname_firstname,
    self_registration:       '0',
    unsubscribe:             '0',
    default_projects_public: '0',
    enabled_scm:             ['Subversion', 'Git'],
  }.each do |k, v|
    if s = Setting.where(name: k).first
      next if s.value == v
      s.value = v
      s.save!
    else
      Setting.create! name: k, value: v
    end
    count += 1
    puts "settings.#{k} = #{v}"
  end
  
  manager = Role.where(id: 3).first
  if manager.permissions.include?(:add_project)
    manager.permissions.delete :add_project
    manager.save!
    count += 1
    puts "'add_project' removed from manager's role."
  end
  
  puts "#{count} value(s) updated." if count > 0
end
