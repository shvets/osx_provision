OSX Provision

Library and thor tasks for provisioning of MacBook computer initial setup for Ruby/Rails development

Add this line to your application's Gemfile:

```bash
gem 'osx_provision'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install osx_provision
```

## Usage

Provisioning of initial computer setup is done as set of thor commands. You can execute them in one shot
or run each command separately.

* Execute all commands:

```bash
thor osx_install:all
```
or separately:

```bash
thor osx_install:brew
thor osx_install:rvm
thor osx_install:postgres
thor osx_install:brew
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
