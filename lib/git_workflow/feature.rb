class GitWorkflow::Feature
  include Opts::DSL

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

      guard_on_branch(branch)
      guard_clean_stage

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

    guard_on_branch branch
    guard_clean_stage

    %x[ git merge --no-ff master ]
  end

private

  def clean_stage?
    check = /nothing to commit \(working directory clean\)/i
    !!(%x[ git status ] =~ check)
  end

  def current_feature
    if current_branch =~ /^features\/(.+)$/
      $1
    end
  end

  def on_feature_branch?
    !!(current_branch =~ /^features\/.+$/)
  end

  def guard_on_branch(name)
    unless current_branch == name
      puts "Please checkout #{name} first!"
      exit(1)
    end
  end

  def guard_on_master
    unless current_branch == 'master'
      puts "Please checkout master first!"
      exit(1)
    end
  end

  def guard_clean_stage
    check = /nothing to commit \(working directory clean\)/i
    unless %x[ git status ] =~ check
      puts "Please commit your changes first!"
      exit(1)
    end
  end

  def list_remotes
    %x[ git remote ].split("\n")
  end

  def current_branch
    lines = %x[ git branch --no-color -a ].split("\n")
    lines.each do |line|
      if line =~ /\*\s+(\S+)/
        return $1
      end
    end
    return nil
  end

  def list_branches(local_only=false)
    branches = []
    if local_only
      lines = %x[ git branch --no-color ].split("\n")
    else
      lines = %x[ git branch --no-color -a ].split("\n")
    end
    lines.each do |line|
      line =~ /\*?\s+(\S+)/
      branches << $1
    end
    branches
  end

end