class GitWorkflow

  require 'opts'

  require 'git_workflow/version'
  require 'git_workflow/feature'

  include Opts::DSL

  def feature(env, args)
    if args.empty?
      args << "list"
    end
    if args.size == 1 and !%w( list open close update ).include?(args.first)
      args.unshift "open"
    end
    GitWorkflow::Feature.new.call(env, args)
  end

end
