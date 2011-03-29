# Installation

## TorqueBox

1. Create temporary directory.

        mkdir bg-tb-tmp
        cd bg-tb-tmp

2. Get latest [TorqueBox build from CI][tb_dev] and put it in earlier created directory.

3. Save [the script][tb_slim] as `slim.rb`.

4. Run the script.

        ruby slim.rb torquebox-dist-bin.zip

5. Move `boxgrinder-torquebox` directory to your home directory.

        mv boxgrinder-torquebox ~/

6. Add symlinks to your `~/.bashrc` file.

        export BG_TORQUEBOX_HOME=$HOME/boxgrinder-torquebox
        export JBOSS_HOME=$BG_TORQUEBOX_HOME/jboss
        export JRUBY_HOME=$BG_TORQUEBOX_HOME/jruby
        export PATH=$JRUBY_HOME/bin:$PATH

## BoxGrinder REST

Get BoxGrinder REST surces from Git repository:

    mkdir ~/git
    cd ~/git
    git clone git://github.com/boxgrinder/boxgrinder-rest.git

### Required gems

    cd boxgrinder-rest
    jruby -S gem install bundler
    jruby -S bundle install

### Deployment file

Create a knob file for TorqueBox.
    
    application:
      root: /home/goldmann/git/boxgrinder-rest
      env: development
    web:
      context: /
    queues:
      # REST => NODE
      /queues/boxgrinder_rest/image:

      # NODE => REST
      /queues/boxgrinder_rest/manage/node:
      /queues/boxgrinder_rest/manage/image:
    topics:
      # REST => NODE
      /topics/boxgrinder_rest/node:
    messaging:
      /queues/boxgrinder_rest/manage/node:  NodeConsumer
      /queues/boxgrinder_rest/manage/image: ImageConsumer

Save above as `~/boxgrinder-torquebox/jboss/server/boxgrinder-rest/deploy/boxgrinder-rest-knob.yml`.

# Launching

    cd ~/boxgrinder-torquebox/jboss
    ./bin/run.sh -b 0.0.0.0 -c boxgrinder-rest

# Verifying

Got to http://localhost:8080/api.

[tb_dev]: http://ci.stormgrind.org/viewLog.html?buildTypeId=bt7&buildId=lastSuccessful&tab=artifacts&guest=1
[tb_slim]: https://gist.github.com/26b4727b769d10fe2a57
