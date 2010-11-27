class GitWorkflow::Feature
  include Opts::DSL
  include GitWorkflow::Helpers

  def list(env, args)
    branches = list_branches(true)
    branches = branches.select { |br| br =~ /^features\// }
    current  = current_branch
    branches = branches.map do |br|
      br =~ /^features\/(.+)$/
      if br == current
        "* #{$1}"
      else
        "  #{$1}"
      end
    end
    puts branches
  end

  argument 'NAME', :type => :string
  def open(env, args)
    guard_clean_stage

    branch     = "features/#{env['NAME']}"
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
  def close(env, args)
    case args.first
    when nil
      env['NAME'] ||= current_feature
      unless env['NAME']
        puts "Please specify a feature!"
        exit 1
      end

      branch = "features/#{env['NAME']}"

      ensure_on_feature_branch(env['NAME'])

      %x[ git checkout master ]
      %x[ git merge --no-ff #{branch} ]
      if clean_stage?
        %x[ git branch -d #{branch} ]
      else
        puts "Please resolve the merge conflicts!\n" \
             "Use any of the following commands to continue:\n" \
             "  git workflow feature close #{env['NAME']} --continue\n" \
             "  git workflow feature close #{env['NAME']} --abort"
      end

    when '--continue'
      unless env['NAME']
        puts "Please specify a feature!"
        exit 1
      end

      guard_on_master
      guard_clean_stage
      %x[ git branch -d #{branch} ]

    when '--abort'
      unless env['NAME']
        puts "Please specify a feature!"
        exit 1
      end

      guard_on_master
      %x[ git add . ]
      %x[ git reset --hard master ]
    end
  end

  argument 'NAME', :type => :string, :required => false
  def update(env, args)
    env['NAME'] ||= current_feature
    unless env['NAME']
      puts "Please specify a feature!"
      exit 1
    end

    branch = "features/#{env['NAME']}"

    ensure_on_feature_branch branch

    %x[ git merge --no-ff master ]
  end

end