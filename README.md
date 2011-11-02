# How to install

## First clone & build a dependency called 'opts'
```shell
git clone https://github.com/fd/opts.git ~/Github/fd
gem build ~/Github/fd/opts/opts.gemspec
```

### If you are using RVM, go to the global gemset
```shell
rvm gemset use global
```

### Install 'opts' gem
```shell
gem install ~/Github/fd/opts/opts-0.0.1.gem
```

## Clone & build this repo
```shell
git clone https://github.com/fd/git_workflow.git ~/Github/fd
gem build ~/Github/fd/git_workflow/git_workflow.gemspec
```

(Check your RVM gemset if necessary) and install this gem

```shell
gem install ~/Github/fd/git_workflow/git_workflow-0.0.1.gem
```