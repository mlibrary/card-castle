# Card Castle

You know, for Trello.  And because House of Cards is a thing on Netflix.

## Dependencies

1. bash
1. rbenv / ruby / bundler
1. [jq](https://stedolan.github.io/jq/)
1. trello

## Instructions

1. [Get yourself a developer api key for trello](https://trello.com/1/appKey/generate).
1. Get a member token: https://trello.com/1/connect?key=<XYZ&gt;&name=card-castle&response_type=token
1. clone this repo
1. run `bundle install --path=.bundle` in the clone
1. create a .env in the clone with

    ```bash
    TRELLO_DEVELOPER_PUBLIC_KEY=<YOUR_API_KEY>
    TRELLO_MEMBER_TOKEN=<YOUR_MEMBER_TOKEN>
    export TRELLO_MEMBER_TOKEN
    export TRELLO_DEVELOPER_PUBLIC_KEY

    ```

1. run `./export.sh`
1. wait for it
1. still waiting?
1. Enjoy your trello/markdown export.  They're in the `boards` directory.
