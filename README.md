# How to install

## First clone & build a dependency called 'opts'
```shell
git clone https://github.com/fd/opts.git ~/Github/fd/opts
cd ~/Github/fd/opts
gem build opts.gemspec
```

### If you are using RVM, go to the global gemset
```shell
rvm gemset use global
```

### Install 'opts' gem
```shell
gem install opts-0.0.1.gem
```

## Clone & build this repo
```shell
git clone https://github.com/fd/git_workflow.git ~/Github/fd/git_workflow
cd ~/Github/fd/git_workflow
gem build git_workflow.gemspec
```

(Check your RVM gemset if necessary) and install this gem

```shell
gem install git_workflow-0.0.1.gem
```