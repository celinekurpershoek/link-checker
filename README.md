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
        url: '{YOUR URL HERE}'
    - name: Get the result
      run: echo "${{steps.link-report.outputs.result}}
```

### todo:
- [ ] Make it possible to ignore specific URLS
