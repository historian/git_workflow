class GitWorkflow::Deployment
  include Opts::DSL
  include GitWorkflow::Helpers

  def environments(env, args)
    branches = list_branches(true)
    branches = branches.select { |br| br =~ /^env\/.+$/ }
    current  = current_branch
    branches = branches.map do |br|
      br =~ /^env\/(.+)$/
      if br == current
        "* #{$1}"
      else
        "  #{$1}"
      end
    end
    puts branches
  end

  argument 'NAME', :type => :string
  def push(env, args)

  end

end