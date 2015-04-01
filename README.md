## Haz Commitz?!

[![Build Status](https://travis-ci.org/rob-murray/haz-commitz.svg?branch=master)](https://travis-ci.org/rob-murray/haz-commitz)
[![Code Climate](https://codeclimate.com/github/rob-murray/haz-commitz.png)](https://codeclimate.com/github/rob-murray/haz-commitz)
[![Coverage Status](https://coveralls.io/repos/rob-murray/haz-commitz/badge.png)](https://coveralls.io/r/rob-murray/haz-commitz)
[![Haz Commitz Status](http://haz-commitz.herokuapp.com/repos/rob-murray/haz-commitz.svg)](http://haz-commitz.herokuapp.com/repos/rob-murray/haz-commitz)


### A GitHub badge service conveying how recently a project has been worked on - Proof of concept at the moment!

Frustrated at having to check whether a GitHub repository has had any commits recently, is it still maintained and can you use it? If the repository were to use a `Haz Commitz` badge then just a simple glance at the badge will give an indication whether the project is actively maintained.

Here it is; [Haz Commitz](http://haz-commitz.herokuapp.com)

## Usage

### Project owner

Simply just add a `Haz Commitz` badge to your repository README, we take care of the rest by checking your project and serving a badge based on a rating.

#### Markdown

```markdown
[![Haz Commitz Status](http://haz-commitz.herokuapp.com/repos/{owner}/{repository}.svg)](http://haz-commitz.herokuapp.com/repos/{owner}/{repository})
```

#### RDOC

```
{<img src="http://haz-commitz.herokuapp.com/repos/{owner}/{repository}.svg" alt="Haz Commitz Status" />}[http://haz-commitz.herokuapp.com/repos/{owner}/{repository}]
```

#### HTML

```
<img src="http://haz-commitz.herokuapp.com/repos/{owner}/{repository}.svg" alt="Haz Commitz Status" />
```

Access your repository stats via a URL like `http://haz-commitz.herokuapp.com/repos/{owner}/{repository}`.

### Project user

Checkout the repository's `Haz Commitz` badge and make a judgment.

Click the badge and come through to our site for some more info about the repository and how we have rated it.

Do you want to use a repository that has not had any commits in 2 years? Maybe. Depending on the repo and use case but maybe not.

### How we work out if the project is maintained

In proof of concept version we simply ask GitHub API when the last commit to the master branch was and then give the repository an un-scientific rating based on when this date.

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
