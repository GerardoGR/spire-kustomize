# Contributor guidelines and Governance

Please see [CONTRIBUTING](https://github.com/spiffe/spiffe/blob/master/CONTRIBUTING.md) and [GOVERNANCE](https://github.com/spiffe/spiffe/blob/master/GOVERNANCE.md) from the SPIFFE project.

# Prerequisites

For local development you will need:

* [docker](https://docs.docker.com/engine/install/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)
* [kind](https://kind.sigs.k8s.io/#installation-and-usage): Used to run the project's end-to-end tests in a sandboxed kubernetes environment.

# End-to-end tests

The current end-to-end test framework was based off the [spire integration tests](https://github.com/spiffe/spire/blob/main/test/integration).
These tests are used to verify that the default kustomize manifests are able to deploy a working spire setup.

When the framework executes a test suite, it performs the following:

1. Provisions a [kind](https://kind.sigs.k8s.io/) cluster with a [predefined
   configuration](e2e/kind.yaml).
1. Applies the [kustomize manifests](manifests/) (found in this repository) in
   the kind cluster.
1. Creates a temporary directory.
1. Copies the contents of the test suite into the temporary directory.
1. Executes scripts that match the `??-*` pattern, ordered lexographically,
   where `??` is a "step number" (i.e. `00-setup`, `01-do-a-thing`).
1. The `teardown` script is executed. Note that the `teardown` script is
   **ALWAYS** executed when the test suite is torn down, independent of test
   suite success/failure. The `teardown` script **MUST** exist or the test will
   not be executed.
1. Temporary directory is removed.

In order for the test to pass, each step script must return a zero status code.

If a step script fails by exiting with a non-zero status code, the test suite
fails and execution moves immediately to the `teardown` script. Subsequent step
scripts are **NOT** executed.

To run the end-to-end tests use:

```shell
$ make e2e
```

For cleaning up the resources created during the e2e tests the `clean-e2e` target can be used:

```shell
$ make clean-e2e
```

## Adding a Test Suite

1. Create a new folder under `suites/`.
1. Add a `README.md` to the test suite and link to it in this document under
   [Test Suites](#test-suites). The README should contain high level details
   about what is being tested by the test suite.
1. Add step scripts (i.e. files matching the `??-*` pattern) that perform the
   requisite steps. These scripts will be executed in lexographic order.
1. Add a `teardown` script that cleans up after the test suite

### Step Scripts

Step scripts are sourced into a subshell with `set -e -o pipefail` set. The
functions within [common](./common) are also sourced into the subshell and
are available for use within the step script.

The working directory of the step script is the temporary directory prepared
for the test suite.

The step script should exit with a non-zero status code if the step fails in
order to trigger test suite failure.

The following environment variables are available to the step scripts:

| Environment Variable  | Description |
| --------- | ----------------|
| `REPODIR` | Path to the root of the git repository.          |
| `ROOTDIR` | Path to the root of the e2e test directory (i.e. `${REPODIR}/e2e` ) |

### Teardown Script

The `teardown` script should clean up anything set up by the step scripts (i.e.
delete kubernetes deployment, etc). It can also optionally log helpful information
when a test suite has failed to aid debuggability.

The working directory of the step script is the temporary directory prepared
for the test suite.

The following environment variables are available to the teardown script:

| Environment Variable  | Description |
| --------- | ----------------|
| `REPODIR` | Path to the root of the git repository.          |
| `ROOTDIR` | Path to the root of the e2e test directory (i.e. `${REPODIR}/e2e` ) |
| `SUCCESS` | If set, indicates the test suite was successful. |

## Test Suites

* [Vanilla kustomize manifests](suites/vanilla/README.md)
