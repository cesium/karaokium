[contributing]: CONTRIBUTING.md
[code_of_conduct]: CODE_OF_CONDUCT.md
[license]: LICENSE.txt

# Karaokium

> 🎤 A Karaoke voting platform

## 📦 Deployment

To release a new version you can run the following script. Make sure you
update the project version number in the `mix.exs` file in advance.

```
bin/release <env>
```

You can start the release with the following script.

```
source .env.<env>
_build/<env>/rel/karaokium/bin/server
```

Please [check the official deployment
guides](https://hexdocs.pm/phoenix/deployment.html) for more information.

## 🤝 Contributing

When contributing to this repository, please first discuss the change you wish
to make via discussions, issues, email, or any other method with the owners of this
repository before making a change.

Please note we have a [Code of Conduct](CODE_OF_CONDUCT.md), please follow it
in all your interactions with the project.

We have a [Contributing Guide][contributing] to help you getting started.

## 📝 License

<img src=".github/brand/cesium-DARK.svg#gh-light-mode-only" width="300">
<img src=".github/brand/cesium-LIGHT.svg#gh-dark-mode-only" width="300">

Copyright (c) 2022, CeSIUM.

This project is licensed under the MIT License - see the [LICENSE][license]
file for details.
