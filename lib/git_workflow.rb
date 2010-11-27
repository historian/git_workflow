class GitWorkflow

  require 'opts'

  require 'git_workflow/version'
  require 'git_workflow/feature'

  include Opts::DSL

  def feature(env, args)
    GitWorkflow::Feature.new.call(env, args)
  end

end
