desc "Setup Redmine."

task :redmine_setup => :environment do
  #host_name = ENV['redmine_host_name']
  #if host_name.blank?
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
    if Setting[k] != v
      puts "Setting[#{k}] = #{v}"
      Setting[k] = v
      count += 1
    end
  end

  manager = Role.where(id: 3).first
  if manager.permissions.include?(:add_project)
    puts "'add_project' removed from manager's role."
    manager.permissions.delete :add_project
    manager.save!
    count += 1
  end

  admin_fullname = ENV['redmine_admin_fullname']
  if admin_fullname.present?
    names = admin_fullname.split(/\s+/)
    if names.length == 2
      admin_username = ENV['redmine_admin_username']
      if admin_username.present?
        if admin = User.where(login: admin_username).first
          if admin.firstname != names[0] || admin.lastname != names[1]
            puts "admin's fullname is #{admin_fullname}"
            admin.firstname = names[0]
            admin.lastname  = names[1]
            admin.save!
            count += 1
          end
        end
      end
    end
  end

  puts "#{count} value(s) updated." if count > 0
end
