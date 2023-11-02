### Challenge Summary
Read Json data, process it and create an output.txt file with the processed information.

To run this, simply clone and run the `challenge.rb` file from the command line. E.G:

```
ruby challenge.rb
```

On successfull run, this will create an `output.txt` file with the results

### Unit Tests
Tests are implemented using the [RSpec library](https://rubygems.org/gems/rspec/versions/3.4.0?locale=en). To run tests, invoke rspec as follow:

```
➜  thrive_challenge git:(main) ✗ rspec
..............

Finished in 0.0051 seconds (files took 0.10142 seconds to load)
14 examples, 0 failures
```

Data Validation
Input files are validated against the expected Json schemas usng the [json-schema gem](https://github.com/voxpupuli/json-schema)