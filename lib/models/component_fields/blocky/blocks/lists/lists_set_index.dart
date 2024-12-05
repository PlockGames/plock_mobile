const block_lists_set_index = {
  "type": 'lists_setIndex',
  "kind": 'block',
  "fields": {
    "MODE": 'SET',
    "WHERE": 'FROM_START',
  },
  "inputs": {
    "LIST": {
      "block": {
        "type": 'variables_get',
        "fields": {
          "VAR": {
            "name": 'list',
          },
        },
      },
    },
  },
};