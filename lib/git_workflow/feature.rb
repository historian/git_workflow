class GitWorkflow::Feature
  include Opts::DSL

  argument 'NAME', :type => :string
  def open(env, args)
    guard_clean_stage
    guard_on_master

    branch     = "features/#{env['NAME']}"
    candidates = list_branches.select { |br| br.include?(branch) }

    if candidates.include?(branch)
      %x[ git checkout #{branch} ]
    elsif candidates.empty?
      %x[ git branch #{branch} -t HEAD ]
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

  argument 'NAME', :type => :string
  def close(env, args)
    p [env, args, list_branches]
  end

private

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
    lines = %x[ git branch -a ].split("\n")
    lines.each do |line|
      if line =~ /\*?\s+(\S+)/
        return $1
      end
    end
    return nil
  end

  def list_branches
    branches = []
    lines = %x[ git branch -a ].split("\n")
    lines.each do |line|
      line =~ /\*?\s+(\S+)/
      branches << $1
    end
    branches
  end

end