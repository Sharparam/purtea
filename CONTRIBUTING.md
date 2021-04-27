# Contributing to Purtea

Purtea is open source and ready to accept your contributions!
To make sure the code stays in a consistent state and is maintainable, we have
some guidelines for you to follow that are outlined in this document.

## Code of Conduct

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct][coc].

## Contribution flow

It's recommended to [create an issue][issues] first or
[open a discussion][discussions] about the thing you want to change, to see if
perhaps there is already a plan to implement what you are proposing. You might
even get some valuable insight into how best to implement your feature! If it's
a bugfix you want to contribute, [submitting a PR][pr] directly can be
preferable if the fix is very small, as there's unlikely to be that much
discussion to be had around it.

You can make a PR for a new feature directly if you want, but chances are
someone is in the works of doing the work already. To save both your own time
and that of the maintainers, it is preferable to get a discussion going first,
and then make the PR.

## Code style

Purtea uses [RuboCop][] for linting. You can run the lints either directly using
RuboCop with the following:

```
$ bundle exec rubocop
```

Or as a Rake task with:

```
$ bundle exec rake rubocop
```

The default Rake task runs both tests and Rubocop, so a good habit is to run
the following when you want to verify your code:

```
$ bundle exec rake
```

If you feel some rule is overzealous or might need an exception somewhere,
feel free to use your own judgement and discuss it in your PR. If it's a bigger
change or exception, then [create an issue][issues] about it.

## Tests

Please write tests for your code. If your code is well tested, it's more likely
to get merged in a speedy manner :).

## Thank you!

If you've decided to contribute something to Purtea, thank you! Any and all
contributions to make the project better are very welcome.

-----

*Pssst! This contribution document itself is also open source, you know. If
you feel like something is missing, can be improved, or be clarified, then feel
free to submit an issue or PR regarding this file!*

[coc]: https://github.com/Sharparam/purtea/blob/master/CODE_OF_CONDUCT.md
[rubocop]: https://rubocop.org/
[issues]: https://github.com/Sharparam/purtea/issues
[discussions]: https://github.com/Sharparam/purtea/discussions
[pr]: https://github.com/Sharparam/purtea/pulls
