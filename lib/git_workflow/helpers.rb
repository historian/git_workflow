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

  def current_feature
    if current_branch =~ /^features\/(.+)$/
      $1
    end
  end

  def on_feature_branch?
    !!current_feature
  end

  def ensure_on_feature_branch(name)
    branch = "features/#{name}"
    guard_branch_exists branch
    unless current_branch == branch
      guard_clean_stage
      %x[ git checkout #{branch} ]
    end
  end

  def guard_on_feature_branch(name=nil)
    if name
      guard_on_branch("features/#{name}")
    elsif !on_feature_branch?
      puts "Please checkout open a feature first!"
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