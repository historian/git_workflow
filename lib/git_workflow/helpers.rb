module GitWorkflow::Helpers

  def clean_stage?
    check = /nothing to commit \(working directory clean\)/i
    !!(%x[ git status ] =~ check)
  end

  def guard_clean_stage(msg=nil)
    check = /nothing to commit \(working directory clean\)/i
    unless %x[ git status ] =~ check
      puts(msg || "Please commit your changes first!")
      exit(1)
    end
  end

  def current_topic
    if current_branch =~ /^topics\/(.+)$/
      $1
    end
  end

  def on_topic_branch?
    !!current_topic
  end

  def ensure_on_topic_branch(name)
    branch = "topics/#{name}"
    guard_branch_exists branch
    unless current_branch == branch
      guard_clean_stage
      %x[ git checkout #{branch} ]
    end
  end

  def guard_on_topic_branch(name=nil)
    if name
      guard_on_branch("topics/#{name}")
    elsif !on_topic_branch?
      puts "Please checkout open a topic first!"
      exit(1)
    end
  end

  def current_environment
    if current_branch =~ /^env\/(.+)$/
      $1
    end
  end

  def on_environment_branch?
    !!current_environment
  end

  def ensure_on_environment_branch(name)
    branch = "env/#{name}"
    guard_branch_exists branch
    unless current_branch == branch
      guard_clean_stage
      %x[ git checkout #{branch} ]
    end
  end

  def guard_on_environment_branch(name=nil)
    if name
      guard_on_branch("env/#{name}")
    elsif !on_environment_branch?
      puts "Please checkout open an environment first!"
      exit(1)
    end
  end

  def guard_on_branch(name)
    unless current_branch == name
      puts "Please checkout #{name} first!"
      exit(1)
    end
  end

  def guard_branch_exists(name)
    unless list_branches(true).include?(name)
      puts "Unknown branch #{name}!"
      exit(1)
    end
  end

  def guard_on_master
    unless current_branch == 'master'
      puts "Please checkout master first!"
      exit(1)
    end
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

  def list_remotes
    %x[ git remote ].split("\n")
  end

end