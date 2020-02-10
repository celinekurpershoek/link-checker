# Broken link check action

This action uses: https://github.com/stevenvachon/broken-link-checker

Find broken links in your website.

## How to use
Create a new file in your repository .github/workflows/action.yml.

Copy-paste the folloing workflow in your action.yml file:

```yml
on: [push]

jobs:
  broken_link_checker_job:
    runs-on: ubuntu-latest
    name: Check for broken links
    steps:
    - name: Check links
      id: link-report
      uses: celinekurpershoek/github-actions-link-checker@master
      with:
        # Required:
        url: 'https://...'
        # optional:
        honorRobotExclusions: false
        ignorePatterns: 'github'
    - name: Get the result
      run: echo "${{steps.link-report.outputs.result}}"
```

## Optional paramters:

### `honorRobotExclusions`
Type: `Boolean`
Default value: `true`
The script does not scan pages that search engine crawlers would not follow.
https://github.com/stevenvachon/broken-link-checker#honorrobotexclusions

### `ignorePatterns`
type: `String`
Default value: `''`
A comma separted string of matched urls to ignore. Check documentation about patterns here: https://github.com/stevenvachon/broken-link-checker#excludedkeywords

## todo:
- [ ] Create issue if broken urls are found
- [ ] Parse each broken link in report on new line


## Test
There is a broken link in this document as a test:
[A broken link](http://jhgfdsadfghjklkjhgfdsasdfgh.com)
