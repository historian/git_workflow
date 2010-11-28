class GitWorkflow

  require 'opts'

  require 'git_workflow/version'
  require 'git_workflow/helpers'
  require 'git_workflow/topic'
  require 'git_workflow/deployment'

  include Opts::DSL

  def topic(env, args)
    if args.empty?
      args << "list"
    end
    if args.size == 1 and !%w( list open close update ).include?(args.first)
      args.unshift "open"
    end
    GitWorkflow::Topic.new.call(env, args)
  end

  def deployment(env, args)
    if args.empty?
      args << "environments"
    end
    GitWorkflow::Deployment.new.call(env, args)
  end

end
