# check-run-actions

This repository contains two custom GitHub Actions ― **check-run: start** and
**check-run: complete**.

> [!NOTE]  
> Both actions can only be triggered by a `workflow_run` event and will exit
> with an error if triggered by other events such as `push` or `pull_request`.

## Check run: start

This action can be used to create a new check run for a specific commit. It is
intended to be used in workflows triggered by a `workflow_run` event, typically
to start additional checks that require secrets that are only available in the
default branch context of a repository.

### Usage

```yaml
- uses: matijs/check-run-actions/start@v1
  with:
    # The name for the check run
    name: ""
```

## Check run: complete

This action can be used to complete a check run for a specific commit. It is
intended to be used in workflows triggered by a `workflow_run` event, typically
to complete check runs that were started by **check-run-start**.

### Usage

```yaml
- uses: matijs/check-run-actions/complete@v1
  with:
    # The check run id that can be obtained from the "check run: start" action
    check-run-id: ""
    # The completion, typically one of "success" or "failure"
    completion: ""
```

## Example using both actions

```yaml
name: my-workflow-run

on:
  workflow_run:
    workflows:
      # Triggered by a workflow called "ci"
      - ci
    types:
      # Start when the workflow called "ci" is completed, to run in parallel,
      # use "requested"
      - completed

permissions:
  # Needed
  checks: write

jobs:
  success-job:
    runs-on: ubuntu-latest
    steps:
      - name: Start check run
        uses: matijs/check-run-actions/start@v1
        id: check-run-start
        with:
          name: ${{ github.job }}

      - name: Simulate success
        env:
          SOME_TOKEN: ${{ secrets.SOME_TOKEN }}
        run: |
          echo "Use ${SOME_TOKEN} in some way"
          exit 0

      - name: Complete check run
        uses: matijs/check-run-actions/complete@v1
        if: ${{ always() }}
        with:
          check-run-id: ${{ steps.check-run-start.outputs.check-run-id }}
          conclusion: ${{ steps.example.outcome }}

  failure-job:
    runs-on: ubuntu-latest
    steps:
      - name: Start check run
        uses: matijs/check-run-actions/start@v1
        id: start
        with:
          name: ${{ github.job }}

      - name: Simulate failure
        env:
          SOME_TOKEN: ${{ secrets.SOME_TOKEN }}
        run: |
          echo "Use ${SOME_TOKEN} in some way"
          exit 1

      - name: Complete check run
        uses: matijs/check-run-actions/complete@v1
        if: ${{ always() }}
        with:
          check-run-id: ${{ steps.start.outputs.check-run-id }}
          conclusion: ${{ steps.example.outcome }}
```

## License

The scripts and documentation in this project are released under the [MIT
License](LICENSE.md)
