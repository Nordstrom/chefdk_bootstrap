# Contributing

Thank you so much for taking the time to contribute! Below is some information that you need to contribute effectively.

## Development

The first time you check out this cookbook, run

    bundle

to download and install the development tools.

## Testing

Three forms of cookbook testing are available:

### Style Checks

    bundle exec rake style

Will run foodcritic (cookbook style) and rubocop (Ruby style/syntax)
checks.

### Unit Tests

    bundle exec rake spec

Will run ChefSpec tests.  It is a good idea to ensure that these
tests pass before committing changes to git.

#### Unit Test Coverage

    bundle exec rake coverage

Will run the ChefSpec tests and report on test coverage.  It is a
good idea to make sure that every Chef resource you declare is covered
by a unit test.

#### Automated Testing with Guard

    bundle exec guard

Will run foodcritic, rubocop (if enabled) and ChefSpec tests
automatically when the associated files change.  If a ChefSpec test
fails, it will drop you into a pry session in the context of the
failure to explore the state of the run.

To disable the pry-rescue behavior, define the environment variable
DISABLE_PRY_RESCUE before running guard:

    DISABLE_PRY_RESCUE=1 bin/guard

### Integration Tests

#### Windows
    bundle exec rake kitchen:all

Will run the test kitchen integration tests.  These tests use Vagrant
and Virtualbox, which must be installed for the tests to execute.

After converging in a virtual machine, ServerSpec tests are executed.
This skeleton comes with a very basic ServerSpec test; refer to
http://serverspec.org for detail on how to create tests.

#### Mac

If you want to run this behind a proxy, export these environment variables before you run the commands below.

```bash
export http_proxy=http://myproxy.example.com:1234
export https_proxy=$http_proxy
```

```bash
# run this from the chefdk_bootstrap directory

berks vendor
sudo -E chef-client -z -c ./client.rb -o chefdk_bootstrap
```
