# Broken link check action

This action uses: https://github.com/stevenvachon/broken-link-checker

Find broken links in your website.

## How to use
Create a new file in your repository .github/workflows/action.yml.

Copy-paste the following workflow in your action.yml file:

```yml
name: Broken link check
on: [push]

jobs:
  broken_link_checker_job:
    runs-on: ubuntu-latest
    name: Check for broken links
    steps:
    - name: Check for broken links
      id: link-report
      uses: ocular-d/link-checker@v0.0.1
      with:
        # Required:
        url: 'https://...'
        # optional:
        honorRobotExclusions: false
        ignorePatterns: 'github,google'
        recursiveLinks: false # Check all urls on all reachable pages (could take a while)
    - name: Get the result
      run: echo "${{steps.link-report.outputs.result}}"
```

## Optional parameters:

### `honorRobotExclusions`
Type: `Boolean`
Default value: `true`
The script does not scan pages that search engine crawlers would not follow.
https://github.com/stevenvachon/broken-link-checker#honorrobotexclusions

### `ignorePatterns`
type: `String`
Default value: `''`
A comma separated string of matched urls to ignore. Check documentation about patterns here: https://github.com/stevenvachon/broken-link-checker#excludedkeywords

### `recursiveLinks`
type: `Boolean`
Default value: `false`
A boolean to do a site-wide check, it will add the `blc` `-ro` param to the command


## todo:
- [ ] Create issue if broken urls are found
- [ ] Parse each broken link in report on new line


## Test
There is a broken link in this document as a test:
[A broken link](http://jhgfdsadfghjklkjhgfdsasdfgh.com)
