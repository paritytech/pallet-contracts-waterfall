
# srml-contracts test site

This repo hosts tests for `srml-contracts`.

# Running

This repo depends on submomdules, make sure you have them:

```
git submodule update --init
```

Then make sure that you built all artifacts required for running the tests by invoking

```
./build.sh
```

To run the tests, launch the substrate node locally and run

```
yarn && yarn test
```
