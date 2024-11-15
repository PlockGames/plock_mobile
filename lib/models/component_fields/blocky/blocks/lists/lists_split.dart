const block_lists_split = {
  "type": 'lists_split',
  "kind": 'block',

  "fields": {
    "MODE": 'SPLIT',
  },
  "inputs": {
    "DELIM": {
      "shadow": {
        "type": 'text',
        "fields": {
          "TEXT": ',',
        },
      },
    },
  },
};