class GitWorkflow::Setup
  include Opts::DSL
  include GitWorkflow::Helpers

  def aliases(env, args)
    system %[ git config --global alias.topic 'workflow topic' ]
    system %[ git config --global alias.deployment 'workflow deployment' ]
  end

end