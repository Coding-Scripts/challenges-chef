[![LinkedIn](https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/linkedin.png)](https://www.linkedin.com/in/dennyzhang001) [![Slack](https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/slack.png)](https://www.dennyzhang.com/slack) [![Github](https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/github.png)](https://github.com/DennyZhang)

File me [tickets](https://github.com/DennyZhang/chef-study/issues) or star [the repo](https://github.com/DennyZhang/chef-study).

<a href="https://github.com/DennyZhang?tab=followers"><img align="right" width="200" height="183" src="https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/fork_github.png" /></a>

Table of Contents
=================

   * [Start docker-compose env](#start-docker-compose-env)
   * [Login to the container, and run procedure](#login-to-the-container-and-run-procedure)
   * [Destroy docker-compose env after testing](#destroy-docker-compose-env-after-testing)

![scenario-101-screenshot.png](../images/scenario-101-screenshot.png)

# Start docker-compose env
docker-compose up -d

# Login to the container, and run procedure
```
docker exec -it my_chef sh

mkdir -p /tmp/berks_cookbooks

cd /tmp/cookbooks/jenkins-demo/
berks vendor /tmp/berks_cookbooks
ls -lth /tmp/berks_cookbooks
```

# Apply Chef update
```
cd /tmp
# From config/node.json, we specify to apply example cookbook
chef-solo -c config/solo.rb -j config/node.json

# After deployment, jenkins is up and running
```

# Verify Jenkins
http://localhost:8080

# Destroy docker-compose env after testing

```
docker-compose down -v
```
