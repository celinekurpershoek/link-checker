# Link checker

This action uses: https://github.com/stevenvachon/broken-link-checker

Find broken links in your website.

## How to use
Create a new file in your repository .github/workflows/action.yml.

Copy-paste the folloing workflow in your action.yml file:

```
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
        url: '{Site url to check}' /* (https://..) */
    - name: Get the result
      run: echo "${{steps.link-report.outputs.result}}"
```

## Options

Create a a blc-config.json file in the root of your repository with this as an example:

```json
{
    "ignorePatterns": [
        {
            "pattern": "linkedin"
        },
        {
            "pattern": "example2"
        }
    ],
    "follow": false 
}

```


### todo:
- [ ] Create issue if broken urls are found
- [ ] Parse each broken link in report on new line


### Test
There is a broken link in this document as a test:
[A broken link](http://jhgfdsadfghjklkjhgfdsasdfgh.com)
