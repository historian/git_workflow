class GitWorkflow::Feature
  include Opts::DSL

  argument 'NAME', :type => :string
  def open(env, args)
    p [env, args, list_branches]
  end

  argument 'NAME', :type => :string
  def close(env, args)
    case args.first
    when nil
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
      guard_on_master
      guard_clean_stage
      %x[ git branch -d #{branch} ]

    when '--abort'
      guard_on_master
      %x[ git add . ]
      %x[ git reset --hard master ]
    end
  end

  argument 'NAME', :type => :string
  def update(env, args)
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

  def list_branches
    branches = []
    lines = %x[ git branch --no-color -a ].split("\n")
    lines.each do |line|
      line =~ /\*?\s+(\S+)/
      branches << $1
    end
    branches
  end

end