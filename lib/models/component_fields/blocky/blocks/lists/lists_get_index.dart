const block_lists_get_index = {
  "type": 'lists_getIndex',
  "kind": 'block',
  "fields": {
    "MODE": 'GET',
    "WHERE": 'FROM_START',
  },
  "inputs": {
    "VALUE": {
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