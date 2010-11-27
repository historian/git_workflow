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
  def push(env, args)

  end

end