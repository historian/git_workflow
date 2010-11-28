class GitWorkflow::Deployment
  include Opts::DSL
  include GitWorkflow::Helpers

  def environments(env, args)
    branches = list_branches(true)
    branches = branches.select { |br| br =~ /^(env\/.+)|master$/ }
    current  = current_branch
    branches = branches.map do |br|
      br =~ /^env\/(.+)$/
      name = $1 || 'master'
      if br == current
        "* #{name}"
      else
        "  #{name}"
      end
    end
    puts branches
  end

  argument 'NAME', :type => :string
  def open(env, args)
    guard_clean_stage

    branch     = "env/#{env['NAME']}"
    candidates = list_branches.select { |br| br.include?(branch) }

    if candidates.include?(branch)
      %x[ git checkout #{branch} ]
    elsif candidates.empty?
      %x[ git branch #{branch} -t master ]
      %x[ git checkout #{branch} ]
    elsif candidates.size == 1
      %x[ git branch #{branch} -t #{candidates.first} ]
      %x[ git checkout #{branch} ]
    else
      puts "To many candidates:"
      puts candidates
      exit(1)
    end
  end

  argument 'NAME', :type => :string, :required => false
  def push(env, args)
    env['NAME'] ||= current_environment
    unless env['NAME']
      puts "Please specify an environment!"
      exit 1
    end

    branch = "env/#{env['NAME']}"

    ensure_on_environment_branch env['NAME']

    system(" git push origin #{branch} ")
  end

  argument 'NAME', :type => :string, :required => false
  def update(env, args)
    env['NAME'] ||= current_environment
    unless env['NAME']
      puts "Please specify an environment!"
      exit 1
    end

    branch = "env/#{env['NAME']}"

    ensure_on_environment_branch env['NAME']

    system(" git merge --no-ff master ")
  end

end