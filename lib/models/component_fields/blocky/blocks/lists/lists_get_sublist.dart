const block_lists_get_sublist = {
  "type": 'lists_getSublist',
  "kind": 'block',
  "fields": {
    "WHERE1": 'FROM_START',
    "WHERE2": 'FROM_START',
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