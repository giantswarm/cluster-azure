
### Please check if PR meets these requirements

- [ ] Results of the diffs have been examined and no unintended changes are being introduced.

### Helper

* to disable the GH Action generating manifests diffs for installations, between target and source branches, comment the `/no_diffs_printing` on the PR.

### Trigger e2e tests

<!--
If for some reason you want to skip the e2e tests, remove the following lines.

Note: Tests are not automatically executed when creating a draft PR
If you do want to trigger the tests while still in draft then please add a comment with the trigger.
-->

/run cluster-test-suites
