class GitWorkflow::Feature
  include Opts::DSL

  argument 'NAME', :type => :string
  def open(env, args)
    p [env, args, list_branches]
  end

  argument 'NAME', :type => :string
  def close(env, args)
    p [env, args, list_branches]
  end

  argument 'NAME', :type => :string
  def update(env, args)
    p [env, args, list_branches]
  end

private

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