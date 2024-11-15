const block_lists_index_of = {
  "type": 'lists_indexOf',
  "kind": 'block',

  "fields": {
    "END": 'FIRST',
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