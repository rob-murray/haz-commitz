## Haz Commitz?! GitHub repository rating service

[![Build Status](https://travis-ci.org/rob-murray/haz-commitz.svg?branch=master)](https://travis-ci.org/rob-murray/haz-commitz)
[![Code Climate](https://codeclimate.com/github/rob-murray/haz-commitz.png)](https://codeclimate.com/github/rob-murray/haz-commitz)
[![Coverage Status](https://coveralls.io/repos/rob-murray/haz-commitz/badge.svg?branch=master&service=github)](https://coveralls.io/github/rob-murray/haz-commitz?branch=master)



### A GitHub badge service displaying repository rating

Having trouble deciding whether to use an open source project? Frustrated at having to check whether the project has had any commits recently, is it still maintained? Should you use it?

If the repository were to use a `Haz Commitz` badge then just a simple glance at the badge will give an indication whether the project is actively maintained based on the rating.


## Usage

### Project owner

Simply just add a `Haz Commitz` badge to your repository README, we take care of the rest by checking your project and serving a badge based on a rating.

#### Markdown

```markdown
[![Haz Commitz Status](https://{host}/repos/{owner}/{repository}.svg)](https://{host}/repos/{owner}/{repository})
```

#### RDOC

```
{<img src="https://{host}/repos/{owner}/{repository}.svg" alt="Haz Commitz Status" />}[https://{host}/repos/{owner}/{repository}]
```

#### HTML

```
<img src="https://{host}/repos/{owner}/{repository}.svg" alt="Haz Commitz Status" />
```

Access your repository stats via a URL like `https://{host}/repos/{owner}/{repository}`.


### Project user

Checkout the repository's `Haz Commitz` badge and make a judgment.

Click the badge and come through to our site for some more info about the repository and how we have rated it.

Do you want to use a repository that has not had any commits in 2 years? Maybe. Or maybe not depending on the repo and use case.


### How we work out the rating

In the proof of concept version we currently use two factors:

* A rating from the last commit date to `master`
* The number of commits to `master` in the past six months
* The number of stars the repository has received

Very un-scientific rating based on this data but we would add more factors in future.


## Build, Test, & Run

Project is just a simple Rails app and uses Octokit gems currently.

```bash
$ bundle install
```

Test it with Rspec.

```bash
$ rspec
```

Run it.

```bash
$ foreman start
```

Run it anywhere you can run Rails applications, for example Heroku - checkout `Procfile`.

It needs an environment variable containing a [GitHub API OAuth token](https://developer.github.com/v3/oauth/).

```bash
$ heroku config:set GITHUB_TOKEN=<API TOKEN HERE>
$ git push heroku master
```


## Contributions

Please use the GitHub pull-request mechanism to submit contributions.

## License

This project is available for use under the MIT software license.
See LICENSE
